# frozen_string_literal: true

# Input for SearchEvents
class EventsSearchCriteria
  attr_accessor :terms

  def initialize(params)
    @terms = Hash[params.map { |key, val| [key.to_sym, val] }]
  end
end
