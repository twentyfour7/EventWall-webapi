# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchOrganization
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (org = Organization.find(id: params[:id])).nil?
      Left(Error.new(:not_found, 'Organization not found'))
    else
      Right(group)
    end
  end
end
