# frozen_string_literal: true

# Search query for events in a group by optional keywords
class OrganizationEventsQuery
  def self.call(org, query)
    # search_events(org)
    query&.any? ? search_events(org, query) : org.events
  end

  private_class_method

  def self.search_events(org, query)
    Event.where(where_clause(query), organization_id: org.id).all
  end

  def self.where_clause(search_terms)
    search_terms.map do |term|
      Sequel.ilike(:id, "%#{term}%")
    end.inject(&:|)
  end
end
