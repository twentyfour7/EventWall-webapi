# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchEvents
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    search = EventsSearchCriteria.new(params)
    org = Organization.find(id: search.org_id)
    if org
      Right(org: org, search: search)
    else
      Left(Error.new(:not_found, 'Organization not found'))
    end
  }

  register :search_events, lambda { |input|
    events = OrganizationEventsQuery.call(input[:org], input[:search].terms)
    results = EventsSearchResults.new(
      input[:search].terms, input[:search].org_id, events
    )
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_events
    end.call(params)
  end
end
