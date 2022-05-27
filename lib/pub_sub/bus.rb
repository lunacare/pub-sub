require_relative "subscriber.rb"
require_relative "publisher.rb"

module PubSub
  module Bus
    def self.included(base)
      base.class_eval do
        include PubSub::Subscriber
        include PubSub::Publisher

        def on_event(...)
          broadcast(...)
        end
      end
    end

    def self.extended(base)
      base.class_eval do
        extend PubSub::Subscriber
        extend PubSub::Publisher

        def self.on_event(...)
          broadcast(...)
        end
      end
    end
  end
end
