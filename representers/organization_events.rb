# frozen_string_literal: true
require_relative 'event'
require_relative 'organization'

# Represents overall organization information for JSON API output
class OrganizationEventsRepresenter < Roar::Decorator
  include Roar::JSON

  property :organization, extend: OrganizationRepresenter, class: Organization
  collection :events, extend: EventRepresenter, class: Event
end
