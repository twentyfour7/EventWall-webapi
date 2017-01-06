# frozen_string_literal: true

# assign event_type
class AssignEventType
  def self.call(org_name, event)
    # preliminarily filtering of event_type
    return '競賽' if ['比賽', '競賽', '大賽', '盃', '獎', '徵文', '徵件'].any? { |s| event.title.include? s } || ['比賽', '競賽', '大賽', '盃', '獎', '徵文', '徵件'].any? { |s| event.summary.include? s }
    # return '徵才' if event.title.include?('徵才' || '招募' || '誠徵')
    return '社團' if ['聚會', '工作坊', '社群'].any? { |s| event.title.include? s }
    return '社團' if org_name.include?('社')
    '講座'
  end
end
