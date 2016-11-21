# frozen_string_literal: true

# Loads data from Facebook group to database
class FindOrganization
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (org = Organization.find(slug: params[:slug])).nil?
      Left(Error.new(:not_found, 'Organization not found'))
    else
      Right(org)
    end
  end
end
