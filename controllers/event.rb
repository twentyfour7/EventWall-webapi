# frozen_string_literal: true

# Event route
class KKEventAPI < Sinatra::Base
  # search events
  get "/#{API_VER}/event/?" do
    results = SearchEvents.call(params)
    if results.success?
      EventsSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # ??????
  # put "/#{API_VER}/event/:id" do
  #   result = UpdateEventFromKKTIX.call(params)
  #   if result.success?
  #     EventRepresenter.new(result.value).to_json
  #   else
  #     ErrorRepresenter.new(result.value).to_status_response
  #   end
  # end

  # get event details through event id
  get "/#{API_VER}/event/detail/:event_id" do
    result = GetEventDetails.call(params)
    if result.success?
      EventRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
