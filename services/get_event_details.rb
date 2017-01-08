# frozen_string_literal: true

# Get event details
class GetEventDetails
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    event_id = params[:event_id]
    if (event = Event.find(id: event_id)).nil?
      Left(Error.new(:not_found, 'Nothing found!'))
    else
      Right(event)
    end
  end
end
