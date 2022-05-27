module PubSub
  class BaseEvent
    attr_accessor :payload

    def initialize(payload)
      @payload = payload
    end
  end
end
