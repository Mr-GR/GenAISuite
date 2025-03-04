# Puma thread pool configuration
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

rails_env = ENV.fetch("RAILS_ENV") { "development" }

if rails_env == "production"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 1 })
  if worker_count > 1
    workers worker_count
  else
    preload_app!
  end
end

# Specifies the `worker_timeout` threshold that Puma will use to wait before terminating a worker
worker_timeout 3600 if rails_env == "development"

# **Ensure Puma listens for HTTP connections**
bind "tcp://0.0.0.0:3000"

# Specifies the `environment` that Puma will run in
environment rails_env

# Specifies the `pidfile` that Puma will use
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Allow Puma to be restarted by `bin/rails restart`
plugin :tmp_restart
