# frozen_string_literal: true
require 'econfig'
require 'shoryuken'

require_relative '../values/init.rb'
require_relative '../config/init.rb'
require_relative '../models/init.rb'
require_relative '../representers/init.rb'
require_relative '../services/init.rb'

# parallel worker to talk to SQS
class LoadEventWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  ENV['AWS_REGION'] = LoadEventWorker.config.AWS_REGION
  ENV['AWS_ACCESS_KEY_ID'] = LoadEventWorker.config.AWS_ACCESS_KEY_ID
  ENV['AWS_SECRET_ACCESS_KEY'] = LoadEventWorker.config.AWS_SECRET_ACCESS_KEY

  Shoryuken.configure_client do |shoryuken_config|
    shoryuken_config.aws = {
      access_key_id:      LoadEventWorker.config.AWS_ACCESS_KEY_ID,
      secret_access_key:  LoadEventWorker.config.AWS_SECRET_ACCESS_KEY,
      region:             LoadEventWorker.config.AWS_REGION
    }
  end

  include Shoryuken::Worker
  shoryuken_options queue: config.PARALLEL_QUEUE, auto_delete: true

  def perform(_sqs_msg, search_term)
    result = SearchFromKKTIX.call(search_term['search'])
    puts "RESULT: #{result.value}"

    ErrorRepresenter.new(result.value).to_status_response
  end
end
