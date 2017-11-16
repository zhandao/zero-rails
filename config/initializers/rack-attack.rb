class Rack::Attack

  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blacklisting and
  # whitelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.current.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.current.to_i/:period}:logins/ip:#{req.ip}"
  throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == 'api/v1/login' && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /login by email param
  #
  # Key: "rack::attack:#{Time.current.to_i/:period}:logins/email:#{req.email}"
  #
  # Note: This creates a problem where a malicious user could intentionally
  # throttle logins for another user and force their login requests to be
  # denied, but that's not very common and shouldn't happen to you. (Knock
  # on wood!)
  throttle("logins/email", :limit => 5, :period => 20.seconds) do |req|
    if req.path == 'api/v1/login' && req.post?
      # return the email if present, nil otherwise
      req.params['email'].presence
    end
  end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  # self.throttled_response = lambda do |env|
  #  [ 503,  # status
  #    {},   # headers
  #    ['']] # body
  # end


  ### Safelists

  # Always allow requests from localhost
  # (blocklist & throttles are skipped)
  # Rack::Attack.safelist('allow from localhost') do |req|
  # Requests are allowed if the return value is truthy
  # '127.0.0.1' == req.ip || '::1' == req.ip
  # end

  ### Blocklists

  # Block requests from 1.2.3.4
  # Rack::Attack.blocklist('block 1.2.3.4') do |req|
  # Requests are blocked if the return value is truthy
  # '1.2.3.4' == req.ip
  # end

  # Block logins from a bad user agent
  # Rack::Attack.blocklist('block bad UA logins') do |req|
  #   req.path == '/login' && req.post? && req.user_agent == 'BadUA'
  # end

  # def self.admin_ip?(req_ip)
  #   YAML.load_file(File.join(Rails.root, 'config/admin_ip.yml')).each do |subnet|
  #     return true if IPAddr.new(subnet).include? req_ip
  #   end
  #   false
  # end
  #
  # blacklist('admin/*') do |req|
  #   req.path =~ %r{^/activeadmin/*} && !admin_ip?(req.ip)
  # end
end

# ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
#   Zero::Log.log_error req.inspect
# end
