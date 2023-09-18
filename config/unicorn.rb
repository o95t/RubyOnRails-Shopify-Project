root = "/home/deployer/apps/shopify_aramex_test/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.shopify_aramex_test.sock"
worker_processes 2
timeout 60
