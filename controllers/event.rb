# frozen_string_literal: true

# Event route
class KKEventAPI < Sinatra::Base
  get "/#{API_VER}/org/:id/event/?" do
    oid = params[:id]
    begin
      org = Organization.find(org_id: oid)
      halt 404, "KKTIX organization (id: #{oid}) not found" unless org

      events = {
        events: Event.where(org_id: org.id).map do |event|
          e = { id: event.id, org_id: org.id }
          e[:title] = event.title if event.title
          e[:description] = event.description if event.description
          e[:datetime] = event.datetime if event.datetime
          e[:location] = event.location if event.location
          e[:cover_img_url] = event.cover_img_url if event.cover_img_url
          e[:attachment_url] = event.attachment_url if event.attachment_url

          { event: e }
        end
      }

      content_type 'application/json'
      events.to_json
    rescue
      halt 500, "Events of KKTIX organization (oid: #{oid}) cannot be processed"
    end
  end

  # Body args (JSON) e.g.: {"id": "nthuion}
  put "/#{API_VER}/event/:id" do
    begin
      event_id = params[:id]
      event = Event.find(event_id)
      halt 400, "Event (id: #{event_id}) is not stored" unless event

      updated_events = KktixEvent::Organization.find(id: event.org_id)
      halt 404, "Organization (id: #{event.org_id}) not found on KKTIX" if updated_events.nil?

      org.events.each do |org_event|
        next unless org_event.id.eql? event.url
        Event.update(
          title:          updated_events.title,
          description:    updated_events.description,
          # datetime:       updated_events&.datetime,
          # location:       updated_events&.location,
          # cover_img_url:  updated_events&.cover_img_url,
          # attachment_url: updated_events&.attachment_url
        )
      end
      event.save

      content_type 'text/plain'
      body ''
    rescue
      content_type 'text/plain'
      halt 500, "Cannot update event (url: #{event_id})"
    end
  end
end
