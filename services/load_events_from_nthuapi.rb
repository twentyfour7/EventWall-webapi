# frozen_string_literal: true

# Loads data from KKTIX organization to database
class LoadEventsFromNTHU
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin
# 
  BASE_URL = 'http://bulletin.web.nthu.edu.tw/files/'
  NTHU_ORG_TO_URL = {
    'art' => '40-1912-5083',
    'academic' => '40-1912-5084',
    'student' => '40-1912-5085'
  }.freeze
  NTHU_ORG_TO_NAME = {
    'art' => '清華藝文活動',
    'academic' => '清華學術活動',
    'student' => '清華學生活動'
  }.freeze

  register :retrieve_org_and_event, lambda { |nthu_org|
    if Organization.find(slug: nthu_org)
      Left(Error.new(:cannot_process, 'Organization already exists'))
    else
      Right(nthu_org)
    end
  }

  register :create_org, lambda { |nthu_org|
    begin
      org = Organization.create(slug: nthu_org, name: NTHU_ORG_TO_NAME[nthu_org], uri: URI.escape(get_nthu_org_uri(nthu_org)))
      Right(org)
    rescue
      Left(Error.new(:cannot_process, 'Cannot create NTHU organization'))
    end
  }

  register :create_event, lambda { |org|
    events = NthuEvent::Event.find(type: org.slug, page: 1)
    puts events
    events.each do |event|
      event_type = AssignEventType.call(org.name, event.title, event.content)
      if Event.find(url: event.url.to_s).nil?
        write_nthu_event(event, org.id, event_type)
      end
    end
    Right(org)
  }

  def self.call(nthu_org)
    puts nthu_org
    Dry.Transaction(container: self) do
      step :retrieve_org_and_event
      step :create_org
      step :create_event
    end.call(nthu_org)
  end

  private_class_method

  def self.write_nthu_event(event, oid, event_type)
    puts event.title, event_type
    # event_detail.datetime.nil? ? '' : DateTime.strptime(event_detail.datetime.split(' ')[0].sub('/', '-'), '%Y-%m-%d').to_date
    Event.create(
      organization_id: oid,
      title:           event.title,
      summary:         event.content,
      datetime:        event.date,
      # location:        content[1].sub('地點：', ''),
      url:             event.url,
      # cover_img_url:   event&.cover_img_url,
      # attachment_url:  event&.attachment_url,
      event_type:      event_type
    )
  end

  def self.get_nthu_org_uri(nthu_org)
    # http://bulletin.web.nthu.edu.tw/files/40-1912-5084-1.php?Lang=zh-tw
    return BASE_URL + NTHU_ORG_TO_URL[nthu_org] + '.php?Lang=zh-tw'
  end

end

