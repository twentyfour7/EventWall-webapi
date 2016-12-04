# frozen_string_literal: true
require_relative 'events'
require_relative 'organization'

# Represents overall organization information for JSON API output
class OrganizationEventsRepresenter < EventsRepresenter
  include Roar::JSON

  property :organization, extend: OrganizationRepresenter, class: Organization
end
