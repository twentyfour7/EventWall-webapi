# frozen_string_literal: true

# Organization route
class KKEventAPI < Sinatra::Base
  # organization information
  get "/#{API_VER}/org/:slug/?" do
    result = FindOrganization.call(params[:slug])

    if result.success?
      puts result.value
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # Manually add an organization. Body args (JSON) e.g.: {"id": "nthuion}
  post "/#{API_VER}/org/?" do
    result = LoadOrgFromKKTIX.call(request.body.read)

    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # get events of an organization
  get "/#{API_VER}/org/:org_slug/event/?" do
    results = LoadOrgEvents.call(params[:org_slug])

    if results.success?
      puts results.value
      OrganizationEventsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
