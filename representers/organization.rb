# frozen_string_literal: true
# frozen_property_literal: true

# Represents overall organization information for JSON API output
class OrganizationRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :org_id
  property :name
  property :url
end
