# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
# Typically this is set to the number of available cores.
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
# this conflicts with phased restart feature. (off by default)
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# Store the pid of the server in the file at "path".
#
pidfile 'tmp/pids/puma.pid'

# Daemonize the server into the background. Highly suggest that
# this be combined with "pidfile" and "stdout_redirect".
#
# daemonize

# Use "path" as the file to store the server info state. This is
# used by "pumactl" to query and control the server.
#
state_path 'tmp/pids/puma.state'

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
#
# stdout_redirect 'log/puma_access.log', 'log/puma_error.log', true

# Bind the server to "url". "tcp://", "unix://" and "ssl://" are the only
# accepted protocols.
#
# The default is "tcp://0.0.0.0:9292".
#
# bind 'tcp://0.0.0.0:9292'
# bind 'unix:///tmp/sockets/puma.sock'
# bind 'unix:///var/run/puma.sock?umask=0111'
# bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'

# Instead of "bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'" you
# can also use the "ssl_bind" option.
#
# ssl_bind '127.0.0.1', '9292', {
#   key: path_to_key,
#   cert: path_to_cert
# }
# for JRuby additional keys are required:
# keystore: path_to_keystore,
# keystore_pass: password

# Code to run before doing a restart. This code should
# close log files, database connections, etc.
#
# This can be called multiple times to add code each time.
#
# on_restart do
#   puts 'On restart...'
# end

# === Cluster mode ===

# Code to run immediately before the master starts workers.
#
# before_fork do
#   puts "Starting workers..."
# end

# Code to run in a worker before it starts serving requests.
#
# This is called everytime a worker is to be started.
#
# on_worker_boot do
#   puts 'On worker boot...'
# end

# Code to run in a worker right before it exits.
#
# This is called everytime a worker is to about to shutdown.
#
# on_worker_shutdown do
#   puts 'On worker shutdown...'
# end

# Code to run in the master right before a worker is started. The worker's
# index is passed as an argument.
#
# This is called everytime a worker is to be started.
#
# on_worker_fork do
#   puts 'Before worker fork...'
# end

# Code to run in the master after a worker has been started. The worker's
# index is passed as an argument.
#
# This is called everytime a worker is to be started.
#
# after_worker_fork do
#   puts 'After worker fork...'
# end

# Allow workers to reload bundler context when master process is issued
# a USR1 signal. This allows proper reloading of gems while the master
# is preserved across a phased-restart. (incompatible with preload_app)
# (off by default)

# prune_bundler

# === Puma control rack application ===

# Start the puma control rack application on "url". This application can
# be communicated with to control the main server. Additionally, you can
# provide an authentication token, so all requests to the control server
# will need to include that token as a query parameter. This allows for
# simple authentication.
#
# Check out https://github.com/puma/puma/blob/master/lib/puma/app/status.rb
# to see what the app has available.
#
# activate_control_app 'unix:///var/run/pumactl.sock'
# activate_control_app 'unix:///var/run/pumactl.sock', { auth_token: '12345' }
# activate_control_app 'unix:///var/run/pumactl.sock', { no_token: true }