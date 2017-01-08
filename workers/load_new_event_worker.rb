# frozen_string_literal: true
require 'econfig'
require 'shoryuken'

require_relative '../values/init.rb'
require_relative '../config/init.rb'
require_relative '../models/init.rb'
require_relative '../representers/init.rb'
require_relative '../services/init.rb'

class LoadNewEventWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.configure_client do |shoryuken_config|
    shoryuken_config.aws = {
      access_key_id:      LoadNewEventWorker.config.AWS_ACCESS_KEY_ID,
      secret_access_key:  LoadNewEventWorker.config.AWS_SECRET_ACCESS_KEY,
      region:             LoadNewEventWorker.config.AWS_REGION
    }

  end

  include Shoryuken::Worker
  shoryuken_options queue: config.EVENT_QUEUE, auto_delete: true

  def perform(_sqs_msg)
    result = LoadEventsFromNTHU.call('')
    puts "RESULT: #{result.value}"

    ErrorRepresenter.new(result.value).to_status_response
  end
end