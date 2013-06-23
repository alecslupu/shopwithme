require "bundler/capistrano"

# load 'deploy/assets'


set :application, "shop-with.me"
role :app, application
role :web, application
role :db,  application, :primary => true

set :user, "root"
# set :bundle_flags, "--deployment --quiet --binstubs"

# the user whch is running the server
# set :user, "www-data"
set :deploy_to, "/var/www/apps/#{application}"

set :use_sudo, false
set :keep_releases, 5

set :rails_env, "production"
set :branch, "master"

set :scm, :git
set :deploy_via, :remote_cache
set :repository, "git@github.com:alecslupu/shopwithme.git"



set :port, 22222

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/sitemaps #{release_path}/public/sitemaps"
    run "ln -nfs #{shared_path}/cache #{release_path}/public" 
    # run "ln -nfs #{shared_path}/cache/brands #{release_path}/public/brands" 
    # run "ln -nfs #{shared_path}/cache/categories #{release_path}/public/categories" 
  end
  
  desc "Sync the public/assets directory."
  task :assets do
    system "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{application}:#{shared_path}/"
  end

  desc "fix permissions "
  task :permission_fix do
    run "cd #{release_path}; mkdir -p #{release_path}/tmp/cache; chmod -R 0777 #{release_path}/tmp/cache"
    run "cd #{release_path}; mkdir -p #{release_path}/tmp/aw; chmod -R 0777 #{release_path}/tmp/aw"
    run "cd #{release_path}; chmod -R 0666 log"
  end

  task :assets_precompile, :roles => :web, :except => { :no_release => true } do
    run "rm -r #{release_path}/public/assets"
    run "cd #{release_path}; rake RAILS_ENV=#{rails_env} assets:precompile"
  end
  task :solr, :roles => :web, :except => { :no_release => true } do 
    run "if [ -d #{release_path}/solr/data ]; then rm -r #{release_path}/solr/data ; fi "
    run "if [ -d #{release_path}/solr/pids ]; then rm -r #{release_path}/solr/pids ; fi "
    run "ln -nfs #{shared_path}/solr/data #{release_path}/solr/data"
    run "ln -nfs #{shared_path}/solr/pids #{release_path}/solr/pids"
  end 
  task :stop_solr, :roles => :web , :except => { :no_release => true } do 
    run "cd #{current_path}; rake RAILS_ENV=#{rails_env} sunspot:solr:stop"
  end 
  task :start_solr, :roles => :web , :except => { :no_release => true } do 
    run "cd #{current_path}; rake RAILS_ENV=#{rails_env} sunspot:solr:start"
  end
  task :stop_resque, :roles => :web , :except => { :no_release => true } do 
    run "(ps -e -o pid,command | grep resque  | grep -v 'grep' | cut -d ' ' -f 1 | xargs -L1 kill -s QUIT) && sleep 3"
    # run "(ps -e -o pid,command | grep resque-scheduler | grep -v 'grep' | cut -d ' ' -f 1 | xargs -L1 kill -s QUIT) && sleep 3"
    run "(ps -e -o pid,command | grep resque  | grep -v 'grep' | cut -d ' ' -f 2 | xargs -L1 kill -s QUIT) && sleep 3"
    # run "(ps -e -o pid,command | grep resque-scheduler | grep -v 'grep' | cut -d ' ' -f 2 | xargs -L1 kill -s QUIT) && sleep 3"
  end 
  task :start_resque, :roles => :web  do  #, :except => { :no_release => true }
    run "(export RAILS_ENV=#{rails_env}  && export QUEUE=* && export COUNT=2 && cd #{current_path} && nohup rake resque:workers &) && sleep 1", :pty => true
    # run "(export RAILS_ENV=#{rails_env} && cd #{current_path} && nohup rake resque:scheduler &) && sleep 1", :pty => true
  end
end

before 'deploy:update_code', 'deploy:stop_resque'
after 'deploy:update_code', 'deploy:symlink_shared', "deploy:migrate", 'deploy:assets_precompile' , 'deploy:solr'
before 'deploy:create_symlink' , 'deploy:permission_fix', 'deploy:stop_solr'
after 'deploy:create_symlink', 'deploy:start_solr', 'deploy:start_resque',  "deploy:cleanup"

