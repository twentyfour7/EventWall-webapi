# frozen_string_literal: true

# Search events from KKTIX external API
class SearchFromKKTIX
  extend Dry::Monads::Either::Mixin

  def self.call(slug)
    if (events = KktixEvent::Event.search(slug)).nil?
      Left(Error.new(:not_found, 'Nothing found!'))
    else
      Right(events)
    end
  end
end
