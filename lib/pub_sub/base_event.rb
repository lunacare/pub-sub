module PubSub
  class BaseEvent
    def self.name
      "base_event"
    end

    attr_accessor :payload

    def initialize(payload)
      @payload = payload
    end
  end
end
