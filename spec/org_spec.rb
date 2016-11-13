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
      post 'api/v0.1/org', { id: HAPPY_KKTIX_ORG_ID }.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should find an organization by giving a correct id' do
      get "api/v0.1/org/#{HAPPY_KKTIX_ORG_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      org_data = JSON.parse(last_response.body)
      org_data['name'].length.must_be :>, 0
      org_data['url'].length.must_be :>, 0
    end

    it 'SAD: should report if an organization is not found' do
      get "api/v0.1/org/#{SAD_KKTIX_ORG_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_KKTIX_ORG_ID
    end
  end

  describe 'Loading and saving a new organization by ID' do
    before do
      DB[:organizations].delete
      DB[:events].delete
    end

    it '(HAPPY) should load and save a new organization by its id' do
      post 'api/v0.1/org', { id: HAPPY_KKTIX_ORG_ID }.to_json, 'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'id'
      body.must_include 'name'
      body.must_include 'url'

      Organization.count.must_equal 1
    end

    it '(BAD) should report error if given invalid URL' do
      post 'api/v0.1/org', { id: SAD_KKTIX_ORG_ID }.to_json, 'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 400
      last_response.body.must_include SAD_KKTIX_ORG_ID
    end

    it 'should report error if organization already exists' do
      2.times do
        post 'api/v0.1/org', { id: HAPPY_KKTIX_ORG_ID }.to_json
      end

      last_response.status.must_equal 422
    end
  end
end
