# frozen_string_literal: true

# Search query for events in a group by optional keywords
class EventsQuery
  def self.call(queries)
    search_events(queries)
  end

  private_class_method

  def self.search_events(queries)
    # return Event.where(keyword_clause(queries[:search].split)).all unless organization_id.nil?
    return Event.where(where_clause(queries.blur_terms)) if queries.exact_terms.empty?
    Event.where(queries.exact_terms).all
  end

  def self.where_clause(search_terms)
    search_terms.map do |key, val|
      Sequel.ilike(key, "%#{val}%")
    end.inject(&:|)
  end
end
