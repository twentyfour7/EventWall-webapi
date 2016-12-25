# frozen_string_literal: true

# assign event_type
class AssignEventType
  extend Dry::Monads::Either::Mixin

  def self.call(org_name, event)
    # preliminarily filtering of event_type
    return '比賽' if event.title.include?('比賽') || event.summary.include?('比賽')
    # return '徵才' if event.title.include?('徵才' || '招募' || '誠徵')
    return '社團' if org_name.include?('社')
    return '講座'
  end
end
