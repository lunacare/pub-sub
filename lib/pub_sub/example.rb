require_relative "active_record/model.rb"
require_relative "bus.rb"
require_relative "publisher.rb"
require_relative "class_forwarding.rb"
require_relative "base_event.rb"

module PubSub
  module Example
    class TestEvent < PubSub::BaseEvent
      def self.name
        "test_event"
      end
    end

    class TestEvent2 < PubSub::BaseEvent
      def self.name
        "test_event_2"
      end
    end

    class TestModel
      extend PubSub::ActiveRecord::Model

      def broadcast_test_event
        broadcast(TestEvent.new("this is payload 1"))
      end

      def broadcast_test_event_2
        broadcast(TestEvent2.new("this is payload 2"))
      end
    end

    class TestLogger
      include PubSub::Subscriber

      on(TestEvent) do |event|
        p ["on(TestEvent)", event.payload]
      end

      def on_unhandled_event(event)
        p ["on_unhandled_event", event.payload]
      end
    end

    TestModel.add_subscriber(TestLogger.new)
    TestModel.new.broadcast_test_event # ["on(TestEvent)", "this is payload 1"]
    TestModel.new.broadcast_test_event_2 # ["on_unhandled_event", "this is payload 2"]
  end
end
