# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require 'rack/test'

require './init.rb'

include Rack::Test::Methods

def app
  KKEventAPI
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
CASSETTE_FILE = 'kktix_api'

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock
end

HAPPY_KKTIX_ORG_URL = 'http://nthuion.kktix.cc'
SAD_KKTIX_ORG_URL = 'http://cowbieNTHU.kktix.cc'
BAD_KKTIX_ORG_URL = 'htt://kktix.bad.url'

HAPPY_KKTIX_ORG_ID = 'nthuion'
SAD_KKTIX_ORG_ID = 'cowbeiNTHU'
SAD_EVENT_ID = 'http://so.sad.no.event'
