# frozen_string_literal: true
# frozen_property_literal: true
require_relative 'event'

# Represents overall event information for JSON API output
class EventsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :events, extend: EventRepresenter, class: Event
end
