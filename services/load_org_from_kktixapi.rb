# frozen_string_literal: true

# Loads data from KKTIX organization to database
class LoadOrgFromKKTIX
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_kktix_org_id, lambda { |kktix_org_id|
    kktix_org_url = 'http://' + kktix_org_id + '.kktix.cc'
    if HTTP.get(kktix_org_url).code.to_s == '404'
      Left(Error.new(:cannot_process, 'URL not recognized as KKTIX organization'))
    else
      Right(kktix_org_id)
    end
  }

  register :retrieve_org_and_event, lambda { |kktix_org_id|
    if Organization.find(org_id: kktix_org_id)
      Left(Error.new(:cannot_process, 'Organization already exists'))
    else
      Right(KktixEvent::Organization.find(kktix_org_id))
    end
  }

  register :create_org_and_event, lambda { |kktix_org|
    org = Organization.create(org_id: kktix_org.oid, name: kktix_org.name, url: kktix_org.uri)
    kktix_org.events.each do |event|
      write_org_event(org, event, kktix_org.oid)
    end
    Right(org)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_kktix_org_id
      step :retrieve_org_and_event
      step :create_org_and_event
    end.call(params)
  end

  private_class_method

  def self.write_org_event(_org, event, oid)
    content = event.content.each_line.to_a
    Event.create(
      org_id:          oid,
      title:           event.title,
      summary:         event.summary,
      published:       event.published,
      datetime:        content[0].sub('時間：', ''),
      location:        content[1].sub('地點：', ''),
      url:             event.url,
      # cover_img_url:   event&.cover_img_url,
      # attachment_url:  event&.attachment_url,
      # event_type:      event&.event_type
    )
  end
end
