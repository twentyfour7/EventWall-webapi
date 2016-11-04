# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require 'rack/test'

require_relative '../app'

include Rack::Test::Methods

def app
  ActAPI
end


FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
CASSETTE_FILE = 'kktix_api'
# GROUPS_CASSETTE = 'groups'

TEST_ORG_ID = 'nthuion'


VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
end