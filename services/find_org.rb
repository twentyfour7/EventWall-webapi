# frozen_string_literal: true

# Loads data from Facebook group to database
class FindOrganization
  extend Dry::Monads::Either::Mixin

  def self.call(slug)
    if (org = Organization.find(slug: slug)).nil?
      LoadOrgFromKKTIX.call(slug)
    else
      Right(org)
    end
  end
end
