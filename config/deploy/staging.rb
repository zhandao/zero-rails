# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

# Optional settings:
#   set :user, 'deployer'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent. ssh -A
#   set :identity_file, key_file_path # ssh -i path, see mina/backend/remote.rb

set :domain,     ''
set :deploy_to,  ''
set :repository, ''
set :branch,     ''
set :user,       ''
# set :identity_file, '~/zhandao.pem'
set :rails_env,  'staging'

# nginx.conf.erb
set :server_name,   ''
set :nginx_etc_dir, '/etc/nginx/'
# set :https, false
# set :http_port, 3000

# remember to set database.yml.
set :db_migrate,     true
set :db_create,      false
set :db_schema_load, false
set :db_rollback,    false
set :db_seed,        false

task :env do
  # puma.erb
  # command %[export MAX_THREADS=2]
  # command %[export WEB_CONCURRENCY=1] # Works
end
