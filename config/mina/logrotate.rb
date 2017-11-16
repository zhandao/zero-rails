namespace :logrotate do
  # Linux - Logrotate: http://www.jianshu.com/p/ea7c2363639c

  desc 'Setup logrotate for all log files in shared/log directory'
  task :setup do
    content = erb('config/logrotate.conf.erb')
    command %(echo '#{content}' | sudo tee /tmp/logrotate > /dev/null)
    command echo_cmd "sudo mv /tmp/logrotate /etc/logrotate.d/#{fetch(:application)}_#{fetch(:stage)}"
  end

  task :setup_logstash do
    content = erb('config/logrotate_logstash.conf.erb')
    command %(echo '#{content}' | sudo tee /tmp/logrotate > /dev/null)
    command echo_cmd "sudo mv /tmp/logrotate /etc/logrotate.d/#{application}_logstash_#{stage}"
  end

  # after 'deploy:setup', 'logrotate:setup'
end
