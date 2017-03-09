# config valid only for current version of Capistrano
lock '3.4.0'

# set :rbenv_type, :user # or :system, depends on your rbenv setup

# in case you want to set ruby version from the file:
set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :application, 'cdc-zero-reporting-system'
set :branch, :develop
set :repo_url, 'https://bitbucket.org/ilab/cdc-zero-reporting-system.git'
set :deploy_user, 'ilab'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
#set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/application.yml', 'config/secrets.yml', 'config/database.yml', 'config/step_manifest.xml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/audios', 'public/uploads')

set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Passenger
set :passenger_restart_with_touch, true

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :backup do

  desc "Upload backup config files."
  task :upload_config do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      upload! StringIO.new(File.read("config/backup/config.rb")), "#{fetch(:backup_path)}/config.rb"
      upload! StringIO.new(File.read("config/backup/models/zero_backup.rb")), "#{fetch(:backup_path)}/models/zero_backup.rb"
    end
  end

  desc "Upload cron schedule file."
  task :upload_cron do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/config"
      execute "touch #{fetch(:backup_path)}/config/cron.log"
      upload! StringIO.new(File.read("config/backup/config/schedule.rb")), "#{fetch(:backup_path)}/config/schedule.rb"

      within "#{fetch(:backup_path)}" do
        set :whenever_command, "bundle exec whenever"
        set :whenever_command, "bundle exec whenever --update-crontab"
      end
    end
  end

end


after 'deploy:finished', 'backup:upload_config'
after 'deploy:finished', 'backup:upload_cron'
