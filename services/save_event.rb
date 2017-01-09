# frozen_string_literal: true

# Loads data from KKTIX group to database
class SaveEvent
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_if_event_exist, lambda { |event_json|
    if (event = Event.find(url: event_json['url'])).nil?
      Right(event: Event.create, updated_data: event_json)
    else
      Right(event: event, updated_data: event_json)
    end
  }

  register :update_event, lambda { |input|
    event = input[:event]
    updated_json = input[:updated_data]
    event_type = AssignEventType.call('NTHU', updated_json['title'], updated_json['content'])
    Right(update_event(event, updated_json, event_type))
  }

  def self.call(event)
    Dry.Transaction(container: self) do
      step :check_if_event_exist
      step :update_event
    end.call(event)
  end

  private_class_method

  def self.update_event(event, updated_json, event_type)
    event.update(
      organization_id: updated_json['oid'],
      title:           updated_json['title'],
      summary:         updated_json['content'],
      datetime:        updated_json['date'],
      url:             updated_json['url'],
      # cover_img_url:   event&.cover_img_url,
      # attachment_url:  event&.attachment_url,
      event_type:      event_type
    )
    event.save
  end
end
