# frozen_string_literal: true

require "singleton"

RSpec.describe PubSub::Publisher do
  before(:example) do
    class TestEvent < PubSub::BaseEvent
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

    class InstancePublisher
      include PubSub::Publisher

      def test_broadcast(...)
        broadcast(...)
      end
    end
  
    class SingletonPublisher
      include Singleton
      include PubSub::Publisher

      def test_broadcast(...)
        broadcast(...)
      end
    end
  
    class ClassPublisher
      extend PubSub::Publisher

      def self.test_broadcast(...)
        broadcast(...)
      end
    end

    @test_event = TestEvent.new("test payload")
    @test_subscriber_1 = TestSubscriber.new
    @test_subscriber_2 = TestSubscriber.new
    @instance_publisher = InstancePublisher.new
    @singleton_publisher = SingletonPublisher.instance
    @class_publisher = ClassPublisher
    @publishers = [@instance_publisher, @singleton_publisher, @class_publisher]
  end

  it "has public add_subscriber method" do
    @publishers.each do |publisher|
      expect(publisher.public_methods.include? :add_subscriber).to be true
    end
  end

  it "has public add_subscribers method" do
    @publishers.each do |publisher|
      expect(publisher.public_methods.include? :add_subscribers).to be true
    end
  end

  it "has public remove_subscriber method" do
    @publishers.each do |publisher|
      expect(publisher.public_methods.include? :remove_subscriber).to be true
    end
  end

  it "has public remove_subscribers method" do
    @publishers.each do |publisher|
      expect(publisher.public_methods.include? :remove_subscribers).to be true
    end
  end

  it "has public yeet_subscriber method" do
    @publishers.each do |publisher|
      expect(publisher.public_methods.include? :yeet_subscriber).to be true
    end
  end

  it "has public yeet_subscribers method" do
    @publishers.each do |publisher|
      expect(publisher.public_methods.include? :yeet_subscribers).to be true
    end
  end

  it "has private broadcast method" do
    @publishers.each do |publisher|
      expect(publisher.private_methods.include? :broadcast).to be true
    end
  end

  it "broadcasts to a subscriber using add_subscriber" do
    @publishers.each do |publisher|
      publisher.add_subscriber(@test_subscriber_1)
      @test_subscriber_1.received.clear
      publisher.test_broadcast("test")
      expect(@test_subscriber_1.received).to eq(["test"])
    end
  end

  it "broadcasts to 2 subscribers using add_subscribers" do
    @publishers.each do |publisher|
      publisher.add_subscribers(@test_subscriber_1, @test_subscriber_2)
      @test_subscriber_1.received.clear
      @test_subscriber_2.received.clear
      publisher.test_broadcast("test")
      expect(@test_subscriber_1.received).to eq(["test"])
      expect(@test_subscriber_2.received).to eq(["test"])
    end
  end

  it "remove_subscriber removes an added subscriber" do
    @publishers.each do |publisher|      
      publisher.add_subscriber(@test_subscriber_1)
      publisher.remove_subscriber(@test_subscriber_1)
      publisher.test_broadcast("test")
      expect(@test_subscriber_1.received).to eq([])
    end
  end

  it "remove_subscribers removes added subscribers" do
    @publishers.each do |publisher|      
      publisher.add_subscribers(@test_subscriber_1, @test_subscriber_2)
      publisher.remove_subscribers(@test_subscriber_1,  @test_subscriber_2)
      publisher.test_broadcast("test")
      expect(@test_subscriber_1.received).to eq([])
    end
  end

  it "broadcast works with events" do
    @publishers.each do |publisher|      
      publisher.add_subscriber(@test_subscriber_1)
      @test_subscriber_1.received.clear
      publisher.test_broadcast(@test_event)
      expect(@test_subscriber_1.received).to eq([@test_event])
    end
  end
end
