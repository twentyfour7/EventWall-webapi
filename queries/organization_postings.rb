# frozen_string_literal: true

# Search query for events in a group by optional keywords
class OrganizationEventsQuery
  # def self.call(org, search_terms)
  #   search_terms&.any? ? search_events(org, search_terms) : org.events
  # end
  def self.call(org)
    search_events(org)
  end

  private_class_method

  def self.search_events(org)
    Event.where(org_id: org.id).all
  end

  # Can be used to implement filter
  def self.where_clause(search_terms)
    search_terms.map do |term|
      Sequel.ilike(:event_type, "%#{term}%")
    end.inject(&:|)
  end
end
