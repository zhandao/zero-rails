namespace :ubuntu do
  task init: :common_env do
    invoke :'ubuntu:install'
  end

  task install: :common_env do
    command %[mkdir -p #{fetch(:deploy_to)}]
    command %[sudo apt-get update]

    # dpkg --configure -a
    command %[sudo apt-get install -y software-properties-common]
    command %[sudo apt-get -y --force-yes dist-upgrade]
    # command %[sudo apt-get install mysql-server mysql-client libmysqlclient-dev]
    command %[sudo apt-get install -y libpq-dev]
    command %[sudo apt-get install -y postgresql-client]
    command %[sudo apt-get install -y redis-server]

    command %[sudo apt-get install -y curl gnupg build-essential]
    command %[sudo apt-get install -y git]
    command %[sudo apt-get install -y libcurl4-openssl-dev]
    command %[sudo apt-get install -y libmysqld-pic]
    command %[sudo apt-get install -y nodejs]
    command %[sudo apt-get install -y nginx]
    command %[sudo apt-get install -y libgmp-dev]
  end
end
