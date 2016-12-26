# frozen_string_literal: true

# assign event_type
class AssignEventType
  def self.call(org_name, event)
    # preliminarily filtering of event_type
    return '比賽' if event.title.include?('比賽' || '競賽' || '大賽' || '盃' || '獎' || '徵文' || '徵件') || event.summary.include?('比賽' || '競賽' || '大賽' || '參賽' || '盃')
    # return '徵才' if event.title.include?('徵才' || '招募' || '誠徵')
    return '社團' if org_name.include?('社')
    '講座'
  end
end
