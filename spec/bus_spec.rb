# frozen_string_literal: true

require "Singleton"

RSpec.describe PubSub::Bus do
  before(:example) do
    class TestPublisher
      include PubSub::Publisher

      def test_broadcast(...)
        broadcast(...)
      end
    end

    class TestSubscriber
      include PubSub::Subscriber

      def received
        @received ||= []
      end

      def on_event(event)
        received << event
      end
    end

    class ClassForwardingBus
      extend PubSub::Bus

      def self.on_event(...)
        broadcast(...)
      end
    end

    class InstanceForwardingBus
      include PubSub::Bus

      def on_event(...)
        broadcast(...)
      end
    end

    class SingletonForwardingBus
      include Singleton
      include PubSub::Bus

      def on_event(...)
        broadcast(...)
      end
    end

    class DoublingBus
      include PubSub::Bus

      def on_event(event)
        broadcast(event)
        broadcast(event)
      end
    end

    @class_forwarding_bus = ClassForwardingBus
    @instance_forwarding_bus = InstanceForwardingBus.new
    @singleton_forwarding_bus = SingletonForwardingBus.instance
    @forwarding_buses = [@class_forwarding_bus, @instance_forwarding_bus, @singleton_forwarding_bus]
    @test_subscriber = TestSubscriber.new
    @test_publisher = TestPublisher.new
    @doubling_bus = DoublingBus.new
  end

  it "has both a publisher and subscriber methods" do
    @forwarding_buses.each do |bus|
      expect(bus.public_methods.include? :add_subscriber).to be true
      expect(bus.public_methods.include? :add_subscribers).to be true
      expect(bus.public_methods.include? :remove_subscriber).to be true
      expect(bus.public_methods.include? :remove_subscribers).to be true
      expect(bus.public_methods.include? :yeet_subscriber).to be true
      expect(bus.public_methods.include? :yeet_subscribers).to be true
      expect(bus.private_methods.include? :broadcast).to be true

      expect(bus.public_methods.include? :on_event).to be true
    end
  end

  it "forwarding buses forward events" do
    @forwarding_buses.each do |bus|
      @test_publisher.add_subscriber(bus)
      bus.add_subscriber(@test_subscriber)
    end
    @test_publisher.test_broadcast("test")
    expect(@test_subscriber.received).to eq(["test", "test", "test"])
  end

  it "custom buses work" do
    @test_publisher.add_subscriber(@doubling_bus)
    @doubling_bus.add_subscriber(@test_subscriber)
    @test_publisher.test_broadcast("test")
    expect(@test_subscriber.received).to eq(["test", "test"])
  end
end
