require 'sinatra'

set :env, :production

require './server.rb'
run Necrohost::Server

