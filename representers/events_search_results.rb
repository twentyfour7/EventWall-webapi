# frozen_string_literal: true
require_relative 'event'

# Represents overall organization information for JSON API output
class EventsSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :search_terms_used
  property :oid
  collection :events, extend: EventRepresenter, class: Event
end
