# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchEvents
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    query = EventsSearchCriteria.new(params)
    if query
      Right(query: query)
    else
      Left(Error.new(:not_found, 'Search terms error'))
    end
  }

  register :search_events, lambda { |input|
    search_terms = input[:query]
    events = EventsQuery.call(search_terms)
    if events.empty?
      Left(Error.new(:not_found, 'Nothing found!'))
    else
      results = EventsSearchResults.new(events, search_terms)
      Right(results)
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_events
    end.call(params)
  end
end
