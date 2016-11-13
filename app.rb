# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'kktix_api'
require 'sequel'
require_relative 'base'
require_relative 'models/organization'
require_relative 'models/event'

require_relative 'config/environment.rb'

# EventAPI web service
class KKEventAPI < Sinatra::Base
  API_VER = 'api/v0.1'

  get '/?' do
    "The latest version of KKTIXEventAPI: /#{API_VER}/"
  end
end
