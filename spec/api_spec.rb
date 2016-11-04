# frozen_string_literal: true
require_relative 'spec_helper'

describe 'API basics' do
  it 'should find configuration information' do
    app.config.KKTIX_ORG_ID.length.must_be :>, 0
  end

  it 'should successfully find the root route' do
    get '/'
    last_response.body.must_include 'Organization'
    last_response.status.must_equal 200
  end
end
