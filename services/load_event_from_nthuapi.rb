# frozen_string_literal: true

# Loads data from KKTIX organization to database
class LoadEventFromNTHU
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :retrieve_org_and_event, lambda { |nthu_type|
    if Organization.find(slug: nthu_type)
      Left(Error.new(:cannot_process, 'Organization already exists'))
    else
      Right(nthu_type)
    end
  }

  register :create_org, lambda { |nthu_type|
    begin
      org = Organization.create(slug: nthu_type, name: "清華公布欄", uri: URI.escape("http://bulletin.web.nthu.edu.tw/bin/home.php"))
      Right(org)
    rescue
      Left(Error.new(:cannot_process, 'Cannot create organization'))
    end
  }

  register :create_event, lambda { |org|
    begin
      events = NthuEvent::Event.find(type: org.slug, page: 1)
      events.each do |event|
        event_type = AssignEventType.call('NTHU', event.title, event.content)
        write_nthu_event(event, org.id, event_type)
      end
      Right(org)
    rescue
      Left(Error.new(:cannot_process, 'Cannot create event'))
    end
  }

  def self.call(slug)
    puts slug
    Dry.Transaction(container: self) do
      step :retrieve_org_and_event
      step :create_org
      step :create_event
    end.call(slug)
  end

  private_class_method

  def self.write_nthu_event(event, oid, event_type)
    puts event.title, event_type
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
end

# EVENT_TYPE_URL = {
#       admin: '40-1912-5074',
#       recruit_internal: '40-1912-5075',
#       recruit_external: '40-1912-5081',
#       admission: '40-1912-5082',
#       art: '40-1912-5083',
#       academic: '40-1912-5084',
#       student: '40-1912-5085',
#       others: '40-1912-5086'
# }.freeze
