# frozen_string_literal: true

require "singleton"

RSpec.describe PubSub::Subscriber do
  before(:example) do
    class TestEvent1 < PubSub::BaseEvent
    end

    class TestEvent2 < PubSub::BaseEvent
    end

    class TestEvent3 < PubSub::BaseEvent
    end

    class TestPublisher
      include Singleton
      include PubSub::Publisher

      def test_broadcast(...)
        broadcast(...)
      end
    end

    class InstanceSubscriber
      include PubSub::Subscriber

      def received
        @received ||= []
      end

      def on_event(event)
        received << event
      end
    end

    class SingletonSubscriber
      include Singleton
      include PubSub::Subscriber

      def received
        @received ||= []
      end

      def on_event(event)
        received << event
      end
    end

    class ClassSubscriber
      extend PubSub::Subscriber

      def self.received
        @received ||= []
      end

      def self.on_event(event)
        received << event
      end
    end

    class EventBaseSubscriber
      include PubSub::Subscriber

      def received
        @received ||= []
      end

      def unhandled
        @unhandled ||= []
      end

      on(TestEvent1, TestEvent2) do |event|
        received << event
      end

      def on_unhandled_event(event)
        unhandled << event
      end
    end

    @test_event_1 = TestEvent1.new("test payload")
    @test_event_2 = TestEvent2.new("test payload")
    @test_event_3 = TestEvent3.new("test payload")
    @test_events = [@test_event_1, @test_event_2, @test_event_3]
    @test_publisher = TestPublisher.instance
    @instance_subscriber = InstanceSubscriber.new
    @instance_subscriber.received.clear
    @singleton_subscriber = SingletonSubscriber.instance
    @singleton_subscriber.received.clear
    @class_subscriber = ClassSubscriber
    @class_subscriber.received.clear
    @event_based_subscriber = EventBaseSubscriber.new
    @subscribers = [@instance_subscriber, @singleton_subscriber, @class_subscriber]
  end

  it "has public on_event method" do
    @subscribers.each do |subscriber|
      expect(subscriber.public_methods.include? :on_event).to be true
    end
  end

  it "has public on_unhandled_event method" do
    @subscribers.each do |subscriber|
      expect(subscriber.public_methods.include? :on_unhandled_event).to be true
    end
  end

  it "has public on class method" do
    expect(@instance_subscriber.class.public_methods.include? :on).to be true
    expect(@singleton_subscriber.class.public_methods.include? :on).to be true
    expect(@class_subscriber.public_methods.include? :on).to be true
  end

  it "on_event gets called via broadcast" do
    @subscribers.each do |subscriber|
      @test_publisher.add_subscriber(subscriber)
    end
    @test_publisher.test_broadcast("test")
    @subscribers.each do |subscriber|
      expect(subscriber.received).to eq(["test"])
    end
  end

  it "on_event works with events" do
    @subscribers.each do |subscriber|
      @test_publisher.add_subscriber(subscriber)
    end
    @test_events.each do |event|
      @test_publisher.test_broadcast(event)
    end
    @subscribers.each do |subscriber|
      expect(subscriber.received).to eq(@test_events)
    end
  end

  it "works with event handlers" do
    @test_publisher.add_subscriber(@event_based_subscriber)
    @test_events.each do |event|
      @test_publisher.test_broadcast(event)
    end
    expect(@event_based_subscriber.received).to eq([@test_event_1, @test_event_2])
  end

  it "on_unhandled_event catches unhandled events" do
    @test_publisher.add_subscriber(@event_based_subscriber)
    @test_events.each do |event|
      @test_publisher.test_broadcast(event)
    end
    expect(@event_based_subscriber.unhandled).to eq([@test_event_3])
  end

  it "on_unhandled_event catches non-events" do
    @test_publisher.add_subscriber(@event_based_subscriber)
    @test_publisher.test_broadcast("test")
    expect(@event_based_subscriber.unhandled).to eq(["test"])
  end

  it "double subscribing does nothing" do
    @subscribers.each do |subscriber|
      @test_publisher.add_subscriber(subscriber)
    end
    @subscribers.each do |subscriber|
      @test_publisher.add_subscriber(subscriber)
    end
    @test_publisher.test_broadcast("test")
    @subscribers.each do |subscriber|
      expect(subscriber.received).to eq(["test"])
    end
  end

  it "unsubscribing works" do
    @subscribers.each do |subscriber|
      @test_publisher.add_subscriber(subscriber)
    end
    @subscribers.each do |subscriber|
      @test_publisher.remove_subscriber(subscriber)
    end
    @test_publisher.test_broadcast("test")
    @subscribers.each do |subscriber|
      expect(subscriber.received).to eq([])
    end
  end
end
