# frozen_string_literal: true

# Loads data from KKTIX organization to database
class LoadOrgFromKKTIX
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  KKTIX_ORG_REGEX = %r{.+\.kktix\.cc}

  register :validate_request_json, lambda { |request_body|
    begin
      url_representation = UrlRequestRepresenter.new(UrlRequest.new)
      Right(url_representation.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, 'URL could not be resolved'))
    end
  }

  register :validate_request_url, lambda { |body_params|
    if (kktix_org_url = body_params['url']).nil?
      Left(:cannot_process, 'URL not supplied')
    else
      Right(kktix_org_url)
    end
  }

  # register :retrieve_kktix_org_html, lambda { |kktix_org_url|
  #   begin
  #     kktix_org_html = HTTP.get(kktix_org_url).body.to_s
  #     Right(kktix_org_html)
  #   rescue
  #     Left(Error.new(:bad_request, 'URL could not be resolved'))
  #   end
  # }

  register :parse_kktix_org_id, lambda { |kktix_org_url|
    if (org_id_match = kktix_org_url.match(KKTIX_ORG_REGEX)).nil?
      Left(Error.new(:cannot_process, 'URL not recognized as KKTIX organization'))
    else
      Right(org_id_match[1])
    end
  }

  register :retrieve_org_and_event, lambda { |kktix_org_id|
    if Organization.find(org_id: kktix_org_id)
      Left(Error.new(:cannot_process, 'Organization already exists'))
    else
      Right(KktixEvent::Organization.find(id: kktix_org_id))
    end
  }

  register :create_org_and_event, lambda { |kktix_org|
    org = Organization.create(org_id: kktix_org.id, name: kktix_org.name, url: kktix_org.url)
    kktix_org.events.each do |kktix_org|
      write_org_event(org, event)
    end
    Right(org)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :validate_request_url
      # step :retrieve_fb_group_html
      step :parse_kktix_org_id
      step :retrieve_org_and_event
      step :create_org_and_event
    end.call(params)
  end

  private_class_method

  def self.write_org_event(org, event)
    kktix_org.add_event(
      org_id:          org.id,
      title:           event.title,
      description:     event.description,
      datetime:        event.datetime,
      location:        event.location,
      url:             event&.url,
      cover_img_url:   event&.cover_img_url,
      attachment_url:  event&.attachment_url,
      event_type:      event.event_type
    )
  end
end