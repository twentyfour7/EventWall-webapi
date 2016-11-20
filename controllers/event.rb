# frozen_string_literal: true

# Event route
class KKEventAPI < Sinatra::Base
  get "/#{API_VER}/org/:id/event/?" do
    results = SearchEvents.call(params)

    if results.success?
      EventsSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Body args (JSON) e.g.: {"id": "nthuion"}
  put "/#{API_VER}/event/:id" do

    result = UpdateEventFromKKTIX.call(params)

    if result.success?
      EventRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
