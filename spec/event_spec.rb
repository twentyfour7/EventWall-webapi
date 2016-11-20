# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Organization routes' do
  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'get events held by the organization' do
    before do
      DB[:organizations].delete
      DB[:events].delete
      post 'api/v0.1/org',
            HAPPY_KKTIX_ORG_ID,
            'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should find events' do
      get "api/v0.1/org/#{Organization.first.org_id}/event"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      JSON.parse(last_response.body).wont_be_empty
    end

    it '(SAD) should report if the event cannot be found' do
      get "api/v0.1/org/#{SAD_KKTIX_ORG_ID}/event"

      last_response.status.must_equal 404
    end
  end
end
