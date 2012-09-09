require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/respond_with'
require 'mustache/sinatra'
require 'dependence'
require 'English'
module Necrohost
  MAX_SLEEP = 60
  class Server < Sinatra::Base
    include ::Dependence
    helpers Sinatra::JSON
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

    formatted_path = -> path {
      %r{#{path}.?(?<format>html|json|xml)?$}
    }

    get '/' do
      hamustache :index
    end

    get formatted_path[%r{/sleep/(?<interval>\d+)}] do |*args|
       @sleep_time = [params[:interval].to_i, MAX_SLEEP].min
       sleep @sleep_time
       formatted_response :sleep, {:sleep => @sleep_time}
    end

    get '/redirected' do
      hamustache :redirected
    end
    
    get '/status/301' do
      redirect '/redirected', 301
    end

    get '/status/302' do
      redirect '/redirected', 302
    end

    get formatted_path[%r{/status/(?<code>\d+)}] do |*matches|
      code = params[:code]
      template_name = template_for_status code
      data = {:status => code}
      formatted_response template_name, data
    end

    not_found do
      hamustache :not_found
    end

    error do
      hamustache :error
    end

    def formatted_response template, data
      format = params[:format] || "html"
      code = (params[:code] || 200).to_i
      accepts = request.accept | [format]
      accepts.each do |type|
        case format || type
          when /html/ 
            halt code, hamustache(template, :locals => data)
          when  /json/
            halt code, json(data)
        end
      end
      error 406
    end

    def template_for_status code
      {
        200 => :ok,
        500 => :error
      }.fetch (code.to_i) { raise ArgumentError, "Code not found" }
    end

    def hamustache template_name, options = {}
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
