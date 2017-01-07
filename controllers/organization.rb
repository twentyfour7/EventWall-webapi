# frozen_string_literal: true

# Organization route
class KKEventAPI < Sinatra::Base
  # get organization information
  # get "/#{API_VER}/org/:slug/?" do
  #   puts '1'
  #   result = FindOrganization.call(params[:slug])

  #   if result.success?
  #     OrganizationRepresenter.new(result.value).to_json
  #   else
  #     ErrorRepresenter.new(result.value).to_status_response
  #   end
  # end


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
