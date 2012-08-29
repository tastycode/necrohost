Bundler.require(:default, :development)
require_relative '../../server'
require 'spinach/capybara'
require 'mocha'
Spinach::FeatureSteps.send(:include, Spinach::FeatureSteps::Capybara)
Capybara.app = Necrohost::Server
