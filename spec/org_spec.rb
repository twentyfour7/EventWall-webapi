# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Organization routes' do
  SAD_KKTIX_ORG_ID = 'sadorg'

  before do
    VCR.insert_cassette GROUPS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'fing an organization by its ID' do
    it 'HAPPY: should find an organization by giving a correct id' do
      get "api/v0.1/org/#{app.config.KKTIX_ORG_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      org_data = JSON.parse(last_response.body)
      org_data['name'].length.must_be :>, 0
      org_data['uri'].length.must_be :>, 0
    end

    it 'SAD: should report if a group is not found' do
      get "api/v0.1/org/#{SAD_KKTIX_ORG_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_KKTIX_ORG_ID
    end
  end

  describe 'get events held by the organization' do
    it 'HAPPY: should find events' do
      get "api/v0.1/org/#{app.config.KKTIX_ORG_ID}/event"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      event_data = JSON.parse(last_response.body)
      event_data['title'].count.must_be :>=, 0
      event_data['published'].count.must_be :>=, 0
    end

    it 'SAD: should report if the event cannot be found' do
      get "api/v0.1/org/#{SAD_KKTIX_ORG_ID}/event"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_KKTIX_ORG_ID
    end
  end
end