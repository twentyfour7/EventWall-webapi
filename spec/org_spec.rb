# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Organization routes' do
  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'find an organization by its ID' do
    before do
      DB[:organizations].delete
      DB[:events].delete
      post 'api/v0.1/org',
           HAPPY_KKTIX_ORG_ID,
           'CONTENT_TYPE' => 'application/json'
    end
    it '(HAPPY) should find an organization by giving a correct ID' do
      get "api/v0.1/org/#{HAPPY_KKTIX_ORG_ID}"
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      org_data = JSON.parse(last_response.body)
      org_data['name'].length.must_be :>, 0
      org_data['uri'].length.must_be :>, 0
    end

    it '(SAD) should report if an organization is not found' do
      get "api/v0.1/org/#{SAD_KKTIX_ORG_ID}"

      last_response.status.must_equal 404
    end
  end

  describe 'Load and save a new organization by its ID' do
    before do
      DB[:organizations].delete
      DB[:events].delete
    end

    it '(BAD) should report error if given invalid ID' do
      post 'api/v0.1/org',
           SAD_KKTIX_ORG_ID,
           'CONTENT_TYPE' => 'application/json'
      last_response.status.must_equal 404
    end
  end
end
