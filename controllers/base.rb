# frozen_string_literal: true

# configure based on environment
class KKEventAPI < Sinatra::Base
  extend Econfig::Shortcut

  API_VER = 'api/v0.1'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
  end

  get '/?' do
    "EventAPI latest version endpoints are at: /#{API_VER}/"
  end
end
