require_relative "subscriber.rb"
require_relative "publisher.rb"

module PubSub
  module Bus
    include PubSub::Subscriber
    include PubSub::Publisher

    def on_event(...)
      broadcast(...)
    end
  end
end
