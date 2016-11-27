# frozen_string_literal: true

# Input for SearchEvents
class EventsSearchCriteria
  attr_accessor :org_id, :terms

  def initialize(params)
    @org_id = params[:org_id]
    @terms = params[:search]
  end
end
