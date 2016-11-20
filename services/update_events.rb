# frozen_string_literal: true

# Loads data from Facebook group to database
class UpdateEventFromKKTIX
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :find_event, lambda { |params|
    event_id = params[:id]
    event = Event.find(id: event_id)
    if event
      Right(event)
    else
      Left(Error.new(:bad_request, 'Event is not stored'))
    end
  }

  register :validate_event, lambda { |event|
    updated_data = KktixEvent::Event.find(id: event.id)
    if updated_data.nil?
      Left(Error.new(:not_found, 'Event not found on KKTIX anymore'))
    else
      Right(event: event, updated_data: updated_data)
    end
  }

  register :update_event, lambda { |input|
    Right(update_event(input[:event], input[:updated_data]))
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_event
      step :validate_event
      step :update_event
    end.call(params)
  end

  private_class_method

  def self.update_event(event, updated_data)
    event.update(
      title:           updated_data.title,
      description:     updated_data.description,
      datetime:        updated_data.datetime,
      location:        updated_data.location,
      url:             updated_data&.url,
      cover_img_url:   updated_data&.cover_img_url,
      attachment_url:  updated_data&.attachment_url,
      event_type:      updated_data.event_type
    )
    event.save
  end
end