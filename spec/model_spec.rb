# frozen_string_literal: true

RSpec.describe PubSub::ActiveRecord::Model do
  before(:example) do
    class TestModel
      extend PubSub::ActiveRecord::Model

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

    @test_model_class = TestModel
    @test_model_instance = TestModel.new
    @test_subscriber = TestSubscriber.new
  end

  it "has both instance and class methods" do
    # instance publisher
    expect(@test_model_instance.public_methods.include? :add_subscriber).to be true
    expect(@test_model_instance.public_methods.include? :add_subscribers).to be true
    expect(@test_model_instance.public_methods.include? :remove_subscriber).to be true
    expect(@test_model_instance.public_methods.include? :remove_subscribers).to be true
    expect(@test_model_instance.public_methods.include? :yeet_subscriber).to be true
    expect(@test_model_instance.public_methods.include? :yeet_subscribers).to be true
    expect(@test_model_instance.private_methods.include? :broadcast).to be true

    # class publisher
    expect(@test_model_class.public_methods.include? :add_subscriber).to be true
    expect(@test_model_class.public_methods.include? :add_subscribers).to be true
    expect(@test_model_class.public_methods.include? :remove_subscriber).to be true
    expect(@test_model_class.public_methods.include? :remove_subscribers).to be true
    expect(@test_model_class.public_methods.include? :yeet_subscriber).to be true
    expect(@test_model_class.public_methods.include? :yeet_subscribers).to be true
    expect(@test_model_class.private_methods.include? :broadcast).to be true
    
    # class subscriber
    expect(@test_model_class.public_methods.include? :on).to be true
    expect(@test_model_class.public_methods.include? :on_event).to be true
    expect(@test_model_class.public_methods.include? :on_unhandled_event).to be true
  end

  it "class forwarding works" do
    @test_model_class.add_subscriber(@test_subscriber)
    @test_model_instance.test_broadcast("test")
    expect(@test_subscriber.received).to eq(["test"])
  end
end
