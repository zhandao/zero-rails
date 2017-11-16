set :domain, ''
set :deploy_to, ''
set :repository, ''
set :branch, ''
set :user, ''

task :env do
  command %w(export RAILS_SERVE_STATIC_FILES=1)
end
