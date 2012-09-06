require 'sinatra/base'
require 'mustache/sinatra'
require 'dependence'
module Necrohost
  MAX_SLEEP = 60
  class Server < Sinatra::Base
    include ::Dependence
    register Mustache::Sinatra #must come before dependencies
    requires :sleep, :as => Kernel 
    requires :haml, :as => :instance
    requires :mustache, :as => :instance

    require "./views/layout"

    Dir["./views/*"].each do |dir|
      require dir
    end

    set :mustache, {
      :views     => 'views/',
      :templates => 'templates/'
    }

    set :environment, :production if ENV['PRODUCTION']

    get '/' do
      render_hamustache:index
    end

    get '/sleep/:interval' do |interval|
       @sleep_time = [interval.to_i, MAX_SLEEP].min
       sleep @sleep_time
       render_hamustache:sleep
    end

    get '/redirected' do
      render_hamustache :redirected
    end

    get '/status/200' do
     render_hamustache :ok
    end

    get '/status/301' do
      redirect '/redirected', 301
    end

    get '/status/302' do
      redirect '/redirected', 302
    end

    get '/status/500' do
      5/0
    end

    not_found do
      render_hamustache :not_found
    end

    error do
      render_hamustache :error
    end

    def render_hamustache template_name, options = {}
      camel_template = camel_case(template_name.to_s).to_sym
      unless Necrohost::Server::Views.const_defined? camel_template
        Necrohost::Server::Views.const_set(camel_template.to_sym, Class.new(Necrohost::Server::Views::Layout))
      end
      haml mustache(template_name, options)
    end

    def camel_case(str)
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split('_').map{|e| e.capitalize}.join
    end
  end
end
