set :rvm_ruby_string, "ruby-1.9.2@necrohost"
set :rvm_type, :system

set :application, "Necrohost"
set :repository,  "git://github.com/vajrapani666/necrohost.git"
set :scm, :git

ssh_options[:port] = 443

set :default_environment, {
  'PRODUCTION' => 1
}
set :user, "vajrapani666"
set :use_sudo, false
set :deploy_to, "/data/necrohost"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "www.necrohost.com"                          # Your HTTP server, Apache/etc
role :app, "www.necrohost.com"                          # This may be the same as your `Web` server
#role :db,  " primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano-unicorn'

