# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchEvents
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    # search = EventsSearchCriteria.new(params)
    org = Organization.find(org_id: params["id"])
    if org
      Right(org)
    else
      Left(Error.new(:not_found, 'Organization not found'))
    end
  }

  register :search_events, lambda { |org|
    events = OrganizationEventsQuery.call(org)
    results = EventsSearchResults.new(
      org.org_id, events
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
