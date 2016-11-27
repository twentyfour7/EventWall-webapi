# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchEvents
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    query = EventsSearchCriteria.new(params)
    org = Organization.find(slug: params['org_slug'])
    if org
      puts query.terms
      Right(org: org, query: query)
    else
      Left(Error.new(:not_found, 'Organization not found'))
    end
  }

  register :search_events, lambda { |input|
    events = OrganizationEventsQuery.call(input[:org], input[:query].terms)
    results = EventsSearchResults.new(
      input[:org].slug, events
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
