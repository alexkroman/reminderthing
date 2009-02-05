require File.expand_path(File.dirname(__FILE__) + "/deploy_local")
require 'mongrel_cluster/recipes'

set :application, "reminderthing.com"
set :repository,  "ssh://alex/var/git/reminder.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :scm_verbose, true
set :keep_releases, 3

role :app, "alex"
role :web, "alex"
role :db,  "alex", :primary => true

after "deploy:update_code", "db:symlink"
after "deploy:setup", "permissions", "db"

task :permissions do
  sudo "chown -R alex:mongrel #{deploy_to}"
  sudo "touch #{shared_path}/log/production.log"
  sudo "chown -R alex:mongrel #{shared_path}/log"
  sudo "chmod -R 2770 #{shared_path}/log"
end

namespace :mongrel do
  namespace :cluster do

  task :start, :roles => :web do
    sudo "/etc/init.d/mongrel_cluster start"
  end

  desc "Stop the web server"
  task :stop, :roles => :web do
    sudo "/etc/init.d/mongrel_cluster stop"
  end

  desc "Restart the web server"
  task :restart, :roles => :web do
    mongrel.cluster.stop
    mongrel.cluster.start
  end

  end
end

namespace :db do
    desc "Create database.yml in the deployed instance."
  
    task :default do
      buffer = YAML::load_file('config/database.template')
      buffer.delete('test')
      buffer.delete('login')
      buffer.delete('development')
       buffer['production']['adapter'] = db_adapter
       buffer['production']['host'] = db_host
       buffer['production']['username'] = db_user
       buffer['production']['password'] = db_password
       buffer['production']['database'] = db_name
       sudo "mkdir -p #{deploy_to}/#{shared_dir}/config"
       sudo "chown alex:mongrel #{deploy_to}/#{shared_dir}/config"
       database_file = "#{deploy_to}/#{shared_dir}/config/database.yml"
       put YAML::dump(buffer), database_file
       sudo "chgrp mongrel #{database_file}"
       sudo "chmod g+r #{database_file}"
     end
   
     task :symlink do
       run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
     end
   
   end
