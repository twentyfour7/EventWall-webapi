# frozen_string_literal: true
# frozen_property_literal: true

# Represents overall event information for JSON API output
class EventRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :organization_id
  property :title
  property :summary
  property :datetime
  property :location
  property :url
  property :cover_img_url
  property :attachment_url
  property :event_type
end
