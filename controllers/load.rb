# frozen_string_literal: true

class KKEventAPI < Sinatra::Base
  # load organization and its events from kktix
  get "/#{API_VER}/load/kk/:slug" do
    result = LoadEventsFromKKTIX.call(params[:slug])
    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # load organization and its events from nthu
  get "/#{API_VER}/load/nthu/:nthuorg" do
    result = LoadEventsFromNTHU.call(params[:nthuorg])
    if result.success?
      OrganizationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
