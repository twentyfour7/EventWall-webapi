# frozen_string_literal: true
require 'sinatra'
require 'econfig'

# configure based on environment
class KKEventAPI < Sinatra::Base
  extend Econfig::Shortcut

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = settings.root

    DB = Sequel.connect(config.DATABASE_URL)
  end

  configure :development, :production do
    require 'hirb'
    Hirb.enable
  end
end
