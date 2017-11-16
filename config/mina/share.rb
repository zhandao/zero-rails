namespace :share do
  task init: :common_env do
    invoke :'share:mk_logstash'
    invoke :'share:mk_shared'
  end

  task mk_logstash: :common_env do
    command %[sudo mkdir -p "/data/logs"]
    command %[sudo chown -R -v #{fetch(:user)}:#{fetch(:user)} "/data/logs"]
  end

  task mk_shared: :common_env do
    %w[log tmp/sockets tmp/pids config].each do |dir|
      command %[mkdir -p "#{ fetch(:shared_path)}/#{dir}"]
      command %[chmod g+rx,u+rwx "#{ fetch(:shared_path)}/#{dir}"]
    end

    %w[database.yml
       settings.local.yml
       secrets.yml
       newrelic.yml].each do |config|
      command %[touch "#{ fetch(:shared_path)}/config/#{config}"]
      command %[echo "-----> Be sure to edit '#{ fetch(:shared_path)}/config/#{config}'."]
    end
  end
end
