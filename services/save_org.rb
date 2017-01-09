# frozen_string_literal: true

# Loads data from KKTIX group to database
class SaveOrganization
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_if_org_exist, lambda { |org_json|
    puts org_json
    if (org = Organization.find(slug: org_json['slug'])).nil?
      Right(org: Organization.create, updated_data: org_json)
    else
      Right(org: org, updated_data: org_json)
    end
  }

  register :update_org, lambda { |input|
    Right(update_org(input[:org], input[:updated_data]))
  }

  def self.call(org)
    Dry.Transaction(container: self) do
      step :check_if_org_exist
      step :update_org
    end.call(org)
  end

  private_class_method

  def self.update_org(org, updated_json)
    org.update(slug: updated_json['slug'], name: updated_json['name'], uri: updated_json['uri'])
    org.save
  end
end
