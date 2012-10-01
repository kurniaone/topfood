require "bundler/capistrano"

default_run_options[:pty] = true

set :application, "Api77"
set :repository, "git@github.com:kurniaone/topfood.git"
set :scm, :git
set :user, "api77"
set :deploy_via, :remote_cache
set :deploy_to, "/home/api77/rails-app"
set :keep_releases, 5
set :use_sudo, false
ssh_options[:forward_agent] = true
set :default_environment, {
  'PATH' => "/home/api77/.rbenv/shims:/home/api77/.rbenv/bin:$PATH"
}

task :dev do
  set :domain, "66.212.17.116"
  set :branch, "master"
  set :rails_env, "development"
  set :migrate_target, :latest
  role :web, domain
  role :app, domain
  role :db, domain, :primary => true
end

task :production do
  set :domain, "66.212.17.116"
  set :branch, "master"
  set :rails_env, "production"
  set :migrate_target, :latest
  role :web, domain
  role :app, domain
  role :db, domain, :primary => true

  # whenever
  # set :whenever_command, "bundle exec whenever"
  # set :whenever_environment, 'production'
  # require "whenever/capistrano"

end


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do
    run "#{try_sudo} touch #{File.join(current_path, "tmp", "restart.txt")}"
  end
end

namespace :symlinks do
  task :database_yml, :roles => :app do
    run "ln -sfn #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile --trace"
    run "cp -rf #{current_path}/public/assets/web-app-theme/themes/default/images/ #{current_path}/public/assets/images/"
    run "cp -rf #{current_path}/public/assets/web-app-theme/themes/default/fonts/ #{current_path}/public/assets/fonts/"
    run "mv #{current_path}/public/assets/ui-*.png #{current_path}/public/assets/images/"
  end
end

after "deploy:finalize_update", "symlinks:database_yml"
after 'deploy:update', 'deploy:migrate'
# after 'deploy:update', 'assets:precompile'
after "deploy:update", "deploy:cleanup"

# Bluepill to monitor
# after "deploy:update", "bluepill:quit", "bluepill:start"
namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => :app do
    run "cd #{current_path}; bundle exec bluepill stop --no-privileged --base-dir #{current_path}/tmp/bluepill --logfile log/bluepill.log"
    run "cd #{current_path}; bundle exec bluepill quit --no-privileged --base-dir #{current_path}/tmp/bluepill --logfile log/bluepill.log"
  end

  desc "Load bluepill configuration and start it"
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec bluepill load #{current_path}/config/production.pill --no-privileged --base-dir #{current_path}/tmp/bluepill --logfile log/bluepill.log"
  end

  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => :app do
    run "cd #{current_path}; bundle exec bluepill status --no-privileged --base-dir #{current_path}/tmp/bluepill --logfile log/bluepill.log"
  end
end

