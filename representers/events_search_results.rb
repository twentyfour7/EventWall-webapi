# frozen_string_literal: true
require_relative 'event'

# Represents overall organization information for JSON API output
class EventsSearchResultsRepresenter < EventsRepresenter
  property :search_terms
end
