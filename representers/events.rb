# frozen_property_literal: true
require_relative 'event'
# Represents overall event information for JSON API output
class EventsRepresenter < Roar::Decorator
  include Roar::JSON

  # Params: property name, represents a Event's stored information, defines the nested object type
  collection :events, extend: EventRepresenter, class: Event
end
