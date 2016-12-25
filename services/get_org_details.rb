# frozen_string_literal: true

# Get org details
class GetOrgDetails
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    org_id = params[:org_id]
    if (org = Organization.find(id: org_id)).nil?
      Left(Error.new(:not_found, 'Nothing found!'))
    else
      Right(org)
    end
  end
end
