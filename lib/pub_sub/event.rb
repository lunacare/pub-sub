module PubSub
  class Event
    attr_accessor :name, :payload

    def initialize(event_name, event_payload)
      name = event_name
      payload = event_payload
    end
  end
end
