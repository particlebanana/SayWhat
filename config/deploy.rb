# deployment tasks
#load 'bundler/capistrano'
load 'config/deploy/symlinks'

set :application, "saywhat"
role :app, "txsaywhat.com"
role :web, "txsaywhat.com"

set :deploy_to, "/usr/share/nginx/html/#{application}"
set :shared_path, "/usr/share/nginx/html/saywhat/shared"

set :scm,        :git
set :repository, "git@github.com:TxSSC/SayWhat-Core.git"
set :branch,     "origin/master"

# Change this to your user id or better yet a deploy user.
set :user, 'cs62'
set :use_sudo, false # if you need sudo privleges for a deploy you fucked up

set :ssh_options, {:forward_agent => true} # use your own github account
set :rails_env, 'production'

default_run_options[:shell] = 'bash'
default_run_options[:pty] = true

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

# Lets dance with some f***ing Unicorns
set :unicorn_binary, "unicorn_rails"
set :unicorn_config, "/usr/share/nginx/html/saywhat/shared/unicorn.rb"
set :unicorn_pid, "/usr/share/nginx/html/saywhat/shared/pids/unicorn.pid"

def unicorn_start_cmd
  "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
end

def unicorn_stop_cmd
  "kill -QUIT `cat #{unicorn_pid}`"
end

def unicorn_restart_cmd
  "kill -USR2 `cat #{unicorn_pid}`"
end

# Deploy the damn thing! 
namespace :deploy do
  desc "Deploy app"
  task :default do
    update
    restart
  end
 
  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    run "git clone #{repository} #{current_path}"
  end
 
  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
  end
   
  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
  
  # override default tasks to make capistrano happy
  desc "Start Unicorn"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Restart Unicorn"
  task :restart, :roles => :app do
    run unicorn_restart_cmd
  end

  desc "Stop Unicorn"
  task :stop, :roles => :app do
    run unicorn_stop_cmd
  end
  
  # Override symlinks task
  desc "No Releases Dir"
  task :symlink, :except => { :no_release => true } do
    #run "cd #{current_path}"
  end
end