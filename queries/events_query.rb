# frozen_string_literal: true

# Search query for events in a group by optional keywords
class EventsQuery
  def self.call(queries)
    search_events(queries)
  end

  private_class_method

  def self.search_events(queries)
    return Event.where(keyword_clause(queries[:search].split)).all unless queries[:search].nil?
    Event.where(where_clause(queries)).all
  end

  def self.where_clause(search_terms)
    search_terms.map do |key, val|
      Sequel.ilike(key, val) if key.to_s.include? 'id'
      Sequel.ilike(key, "%#{val}%")
    end.inject(&:|)
  end

  def self.keyword_clause(search_terms)
    search_terms.map do |word|
      Sequel.ilike(:title, "%#{word}%")
    end.inject(&:|)
  end
end
