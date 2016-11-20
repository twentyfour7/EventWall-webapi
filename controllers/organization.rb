# frozen_string_literal: true

# Organization route
class KKEventAPI < Sinatra::Base
  get "/#{API_VER}/org/:id/?" do
    result = FindOrganization.call(params)

    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # Body args (JSON) e.g.: {"id": "nthuion}
  post "/#{API_VER}/org/?" do
    result = LoadOrgFromKKTIX.call(request.body.read)

    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
