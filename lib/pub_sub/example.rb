require "singleton"

require_relative "active_record/model.rb"
require_relative "bus.rb"
require_relative "publisher.rb"
require_relative "class_forwarding.rb"
require_relative "base_event.rb"
require_relative "subscriber_worker"

module PubSub
  module Example
    class TestEvent1 < PubSub::BaseEvent
    end

    class TestEvent2 < PubSub::BaseEvent
    end

    class TestEvent3 < PubSub::BaseEvent
    end

    class TestLogger
      include Singleton
      include PubSub::Subscriber

      on(TestEvent1, TestEvent3) do |event|
        p ["on(TestEvent)", event.payload]
      end

      def on_unhandled_event(event)
        p ["on_unhandled_event", event.payload]
      end
    end

    class TestAsyncLogger < SubscriberWorker
      on(TestEvent1, TestEvent3) do |event|
        p ["async", "on(TestEvent)", event.payload]
      end

      def on_unhandled_event(event)
        p ["async", "on_unhandled_event", event.payload]
      end
    end

    class TestModel
      extend PubSub::ActiveRecord::Model

      add_subscriber(TestLogger.instance)
      add_subscriber(TestAsyncLogger)

      def broadcast_test_event_1
        broadcast(TestEvent1.new("this is payload 1"))
      end

      def broadcast_test_event_2
        broadcast(TestEvent2.new("this is payload 2"))
      end

      def broadcast_test_event_3
        broadcast(TestEvent3.new("this is payload 3"))
      end
    end

    TestModel.new.broadcast_test_event_1 # ["on(TestEvent)", "this is payload 1"]
    TestModel.new.broadcast_test_event_2 # ["on_unhandled_event", "this is payload 2"]
    TestModel.new.broadcast_test_event_3 # ["on(TestEvent)", "this is payload 3"]
  end
end
