require "bundler/capistrano"
require 'capistrano-unicorn'


server "127.0.0.1", :web, :app, :db, primary: true
# server "10.47.8.33", :web, :app, :db, primary: true

set :application, "shopify_aramex_test"
set :user, "andriy"
# set :port, 8000
set :deploy_to, "/home/#{user}/apps/#{application}"
# set :deploy_via, :remote_cache
set :deploy_via, :copy
set :use_sudo, false

set :scm, "git"
set :repository, "git@bitbucket.org:imranshaikh/#{application}.git"
# set :repository, "git@github.com:movingahead/#{application}.git"
set :repository, "."
set :local_repository, "."
set :branch, "master"

default_run_options[:pty] = true
# default_run_options[:shell] = '/bin/bash --login'
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  # after 'deploy:update' do
  #   memcached.flush
  # end

  # Not being used here, as we are using local deploy
  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  before "deploy", "deploy:check_revision"
end

