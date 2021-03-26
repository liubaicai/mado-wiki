# frozen_string_literal: true

require 'sinatra'

require './app/router/index'

use Rack::Logger

configure do
  set :port, 9981
  set :logging, true
  set :logger, Logger.new(STDOUT)
  set :static, true
  set :static_cache_control, [:public, :max_age => 2592000]
end

configure :development do
  set :server, :webrick
end

use MaDo

get '/*' do
  raise Sinatra::NotFound
end
