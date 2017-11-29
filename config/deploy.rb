require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/puma'
require 'mina/rvm'

Dir['config/mina/*.rb'].each do |file|
  file_name = File.basename(file, '.rb')
  require File.expand_path("../mina/#{file_name}", __FILE__)
end

# Doc: after first deployed, remember to set these files on your server.
# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, [ ]).push(
    'log',
    'tmp/pids',
    'tmp/sockets'
)
set :shared_files, fetch(:shared_files, [ ]).push(
    'config/database.yml',
    'config/settings.local.yml',
    'config/secrets.yml',
    'config/newrelic.yml',
    'config/puma.rb'
)

set :lograte_file, "/data/logs/logstash_lograge_zero-rails_#{fetch(:rails_env)}.log"

task common_env: :env do
end

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task remote_environment: :common_env do
  # For those using RVM, use this to load an RVM version@gemset.
  set :rvm_use_path, '/etc/profile.d/rvm.sh' # set the path of rvm if default setting wrong.
  invoke :'rvm:use', 'ruby-2.4.1@default'
end

# Doc: usage: `mina staging c`
desc "Starts an interactive rails console."
task c: :remote_environment do
  invoke :'console'
end

task log: :remote_environment do
  invoke :'log'
end

desc 'Tail lograte log from server'
task l: :remote_environment do
  command %{tailf -100 #{fetch(:lograte_file)}}
end

desc 'Tail original log from server'
task ol: :remote_environment do
  command %{tailf -100 #{fetch(:deploy_to)}/shared/log/#{fetch(:rails_env)}.log}
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task setup: :common_env do
  invoke :'ubuntu:init'
  invoke :'rvm:init' # TODO: something maybe wrong at the task
  invoke :'share:init'
  invoke :'nginx:init'
  invoke :'puma:init'
  invoke :'logrotate:setup'
end

desc "Deploys the current version to the server."
task deploy: :remote_environment do
  on :before_hook do
    # Put things to run locally before ssh
  end
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    # command %[RAILS_ENV=#{fetch(:rails_env)} bundle install --without development]
    invoke :'bundle:install'

    invoke :'rails:db_create'      if fetch(:db_create)
    invoke :'rails:db_schema_load' if fetch(:db_schema_load)
    invoke :'rails:db_migrate'     if fetch(:db_migrate)
    invoke :'rails:db_rollback'    if fetch(:db_rollback)
    command %[RAILS_ENV=#{fetch(:rails_env)} rails db:seed] if fetch(:db_seed)

    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'


    on :launch do
      in_path(fetch(:current_path)) do
        command %{touch tmp/restart.txt}
      end
      command %[touch "#{fetch(:lograte_file)}"]
      invoke :'puma:start'          if fetch(:first_start_puma)
      invoke :'puma:phased_restart' unless fetch(:first_start_puma)
      # invoke :'puma:hard_restart'
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local) { say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
#  - http://nadarei.co/mina/
