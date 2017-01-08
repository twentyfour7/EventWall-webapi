# frozen_string_literal: true

# configure :development do
#   def reload!
#     # Tux reloading: https://github.com/cldwalker/tux/issues/3
#     exec $PROGRAM_NAME, *ARGV
#   end
# end

# configure based on environment
class KKEventAPI < Sinatra::Base
  extend Econfig::Shortcut

  # config Shoryuken
  Shoryuken.configure_server do |config|
    config.aws = {
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    }
  end

  API_VER = 'api/v0.1'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
  end

  after do
    content_type 'application/json'
  end

  get '/?' do
    {
      status: 'OK',
      message: "EventAPI latest version endpoints are at: /#{API_VER}/"
    }.to_json
  end
end
