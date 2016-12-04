# frozen_string_literal: true

# Input for SearchEvents
class EventsSearchCriteria
  attr_accessor :exact_terms, :blur_terms

  def initialize(params)
    @exact_terms = {}
    @blur_terms = {}
    params.each do |key, val|
      if key.to_s.include? 'id'
        @exact_terms[key.to_sym] = val
      else
        @blur_terms[key.to_sym] = val
      end
    end
  end
end
