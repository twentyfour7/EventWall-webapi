# frozen_string_literal: true

# Loads data from KKTIX group to database
class FindOrganization
  extend Dry::Monads::Either::Mixin

  def self.call(slug)
    if (org = Organization.find(slug: slug)).nil?
      LoadEventsFromKKTIX.call(slug)
    else
      Right(org)
    end
  end
end
