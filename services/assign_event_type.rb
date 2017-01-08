# frozen_string_literal: true

# assign event_type
class AssignEventType
  def self.call(org_name, title, content)
    # preliminarily filtering of event_type
    return 'Art' if org_name == '清華藝文活動'
    return 'Contest' if ['比賽', '競賽', '大賽', '盃', '徵文', '徵件'].any? { |s| title.include? s } || ['比賽', '競賽', '大賽', '盃', '徵文', '徵件'].any? { |s| content.include? s }
    return 'Recruit' if ['徵才', '招募', '誠徵', '實習'].any? { |s| title.include? s }
    return 'Community' if ['聚會', '社群'].any? { |s| title.include? s }
    return 'Club' if org_name.include?('社')
    'Academic'
  end
end
