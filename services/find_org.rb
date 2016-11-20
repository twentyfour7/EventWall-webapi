# frozen_string_literal: true

# Loads data from Facebook group to database
class FindOrganization
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (org = Organization.find(org_id: params[:id])).nil?
      Left(Error.new(:not_found, 'Organization not found'))
    else
      Right(org)
    end
  end
end