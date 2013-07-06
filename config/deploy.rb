require "bundler/capistrano"

# load 'deploy/assets'


set :application, "productrepository.com"
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
set :branch, "product_repository"

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
    run "cd #{release_path}/public; touch assets"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "rm #{release_path}/config/newrelic.yml;ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"

  end
  
  desc "Sync the public/assets directory."
  task :assets do
    system "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{application}:#{shared_path}/"
  end

  desc "fix permissions "
  task :permission_fix do
    run "cd #{release_path}; mkdir -p #{release_path}/tmp/cache; chmod -R 0777 #{release_path}/tmp/cache"
    run "cd #{release_path}; chmod -R 0666 log"
  end

  task :assets_precompile, :roles => :web, :except => { :no_release => true } do
    run "rm -r #{release_path}/public/assets"
    run "cd #{release_path}; rake RAILS_ENV=#{rails_env} assets:precompile"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared', "deploy:migrate" , 'deploy:assets_precompile'
before 'deploy:create_symlink' , 'deploy:permission_fix'
after 'deploy:create_symlink', "deploy:cleanup"

