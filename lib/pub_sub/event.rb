module PubSub
  class Event
    attr_accessor :payload

    def initialize(payload)
      @payload = payload
    end
  end
end
