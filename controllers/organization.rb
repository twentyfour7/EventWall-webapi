# frozen_string_literal: true

# Organization route
class KKEventAPI < Sinatra::Base
  get "/#{API_VER}/org/:id/?" do
    oid = params[:id]
    begin
      org = Organization.find(org_id: oid)

      content_type 'application/json'
      { id: org.id, name: org.name, url: org.url }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "KKTIX organization (org_id: #{oid}) not found"
    end
  end

  # Body args (JSON) e.g.: {"id": "nthuion}
  post "/#{API_VER}/org/?" do
    begin
      body_params = JSON.parse request.body.read
      oid = body_params['id']

      if Organization.find(org_id: oid)
        halt 422, "Organization (id: #{oid}) already exists"
      end

      org = KktixEvent::Organization.find(oid)
    rescue
      content_type 'text/plain'
      halt 400, "KKTIX Organization (id: #{oid}) could not be found"
    end

    begin
      organization = Organization.create(org_id: org.oid, name: org.name, url: org.uri)

      org.events.each do |event|
        Event.create(
          org_id:         organization.id,
          title:          event.title,
          description:    event.content,
          # datetime:       event&.datetime,
          # location:       event&.location,
          url:            event&.url
          # cover_img_url:  event&.cover_img_url,
          # attachment_url: event&.attachment_url
        )
      end

      content_type 'application/json'
      { id: organization.id, name: organization.name, url: organization.url }.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create organization (id: #{oid})"
    end
  end
end
