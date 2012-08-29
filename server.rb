require 'sinatra/base'
require 'mustache/sinatra'

module Necrohost
  class Server < Sinatra::Base
    register Mustache::Sinatra
    require './views/layout'
    require './views/index'

    set :mustache, {
      :views     => 'views/',
      :templates => 'templates/'
    }

    get '/' do
      haml mustache(:index)
    end
  end
end
