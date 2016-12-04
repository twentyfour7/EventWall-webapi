# frozen_string_literal: true

# Loads event of an organization
class LoadOrgEvents
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_kktix_org_id, lambda { |kktix_org_slug|
    result = FindOrganization.call(kktix_org_slug)
    organization = result.value
    if result.success?
      Right(organization)
    else
      Left(result.value)
    end
  }

  register :load_events_from_database, lambda { |organization|
    result = SearchEvents.call(organization_id: organization.id)
    events = result.value.events
    Right(OrganizationEvents.new(organization, events))
  }

  def self.call(slug)
    Dry.Transaction(container: self) do
      step :validate_kktix_org_id
      step :load_events_from_database
    end.call(slug)
  end
end
