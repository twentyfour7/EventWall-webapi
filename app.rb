# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'kktix_api'

# GroupAPI web service
class KKEventAPI < Sinatra::Base
  extend Econfig::Shortcut
 #KktixEvent::Organization
  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  API_VER = 'api/v0.1'

  get '/?' do
    "The latest version of KKEventAPI: /#{API_VER}/"
  end

  get "/#{API_VER}/org/:kktix_oid/?" do
    oid = params[:kktix_oid]
    begin
      org = KktixEvent::Organization.find(oid)

      content_type 'application/json'
      { name: org.name, uri: org.uri }.to_json
    rescue
      halt 404, "KKTIX organization (id: #{oid}) not found"
    end
  end

  get "/#{API_VER}/org/:kktix_oid/event/?" do
    oid = params[:kktix_oid]
    begin
      org = KktixEvent::Organization.find(oid)

      content_type 'application/json'
      { 
        org.events.each do |event|
          title: org.title, 
          published: org.published
        end
      }.to_json
    rescue
      halt 404, "Events of KKTIX organization (id: #{oid}) feed"
    end
  end
end
