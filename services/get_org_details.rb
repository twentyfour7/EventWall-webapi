# frozen_string_literal: true

# get details and events of an organization
class GetOrgDetails
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_if_org_exist, lambda { |org_id|
    if (org = Organization.find(id: org_id)).nil?
      Left(Error.new(:not_found, 'Nothing found!'))
    else
      Right(org)
    end
  }

  register :load_events_from_database, lambda { |org|
    result = SearchEvents.call(organization_id: org.id)
    # puts result
    events = result.value.events
    Right(OrganizationEvents.new(org, events))
  }

  def self.call(params)
    org_slug = params[:org_id]
    Dry.Transaction(container: self) do
      step :check_if_org_exist
      step :load_events_from_database
    end.call(org_slug)
  end
end
