# frozen_string_literal: true

# Organization route
class KKEventAPI < Sinatra::Base
  # load organization and its events from nthu
  post "/#{API_VER}/org/" do
    org_json = JSON.parse request.body.read
    result = SaveOrganization.call(org_json)

    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # get organization information
  get "/#{API_VER}/org/:slug/?" do
    result = FindOrganization.call(params[:slug])

    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # get organization details through event id
  get "/#{API_VER}/org/detail/:org_id" do
    result = GetOrgDetails.call(params)
    if result.success?
      OrganizationEventsRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
