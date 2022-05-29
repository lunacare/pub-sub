# frozen_string_literal: true

require "active_record"

RSpec.describe PubSub::ActiveRecord::Model do
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:'
  )

  ActiveRecord::Schema.define do
    create_table :test_models, force: true do |t|
      t.string :name
    end
  end

  before(:example) do
    class TestModel < ActiveRecord::Base
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

  it "calls create callbacks" do
    @test_model_class.add_subscriber(@test_subscriber)
    @test_model_class.create!(name: "test")
    expect(@test_subscriber.received.map { |event| event.class.name }).to eq([
      "PubSub::ActiveRecord::Events::AfterInitializeEvent",
      "PubSub::ActiveRecord::Events::BeforeValidationEvent",
      "PubSub::ActiveRecord::Events::AfterValidationEvent",
      "PubSub::ActiveRecord::Events::BeforeSaveEvent",
      "PubSub::ActiveRecord::Events::BeforeCreateEvent",
      "PubSub::ActiveRecord::Events::AfterCreateEvent",
      "PubSub::ActiveRecord::Events::AfterSaveEvent",
      "PubSub::ActiveRecord::Events::AfterCommitEvent",
      "PubSub::ActiveRecord::Events::AfterCreateCommitEvent",
      "PubSub::ActiveRecord::Events::CreateChangeEvent"
    ])
  end

  it "calls update callbacks" do
    instance = @test_model_class.create!(name: "test")
    @test_model_class.add_subscriber(@test_subscriber)
    instance.update!(name: "test2")
    expect(@test_subscriber.received.map { |event| event.class.name }).to eq([
      "PubSub::ActiveRecord::Events::BeforeValidationEvent",
      "PubSub::ActiveRecord::Events::AfterValidationEvent",
      "PubSub::ActiveRecord::Events::BeforeSaveEvent",
      "PubSub::ActiveRecord::Events::BeforeUpdateEvent",
      "PubSub::ActiveRecord::Events::AfterUpdateEvent",
      "PubSub::ActiveRecord::Events::AfterSaveEvent",
      "PubSub::ActiveRecord::Events::AfterCommitEvent",
      "PubSub::ActiveRecord::Events::AfterUpdateCommitEvent",
      "PubSub::ActiveRecord::Events::UpdateChangeEvent",
    ])
  end

  it "calls destroy callbacks" do
    instance = @test_model_class.create!(name: "test")
    @test_model_class.add_subscriber(@test_subscriber)
    instance.destroy!
    expect(@test_subscriber.received.map { |event| event.class.name }).to eq([
      "PubSub::ActiveRecord::Events::BeforeDestroyEvent",
      "PubSub::ActiveRecord::Events::AfterDestroyEvent",
      "PubSub::ActiveRecord::Events::AfterCommitEvent",
      "PubSub::ActiveRecord::Events::AfterDestroyCommitEvent",
      "PubSub::ActiveRecord::Events::DestroyChangeEvent"
    ])
  end

  it "calls rollback callbacks" do
    @test_model_class.add_subscriber(@test_subscriber)
    @test_model_class.transaction do
      @test_model_class.create!(name: "test")
      raise ActiveRecord::Rollback
    end
    expect(@test_subscriber.received.map { |event| event.class.name }).to eq([
      "PubSub::ActiveRecord::Events::AfterInitializeEvent",
      "PubSub::ActiveRecord::Events::BeforeValidationEvent",
      "PubSub::ActiveRecord::Events::AfterValidationEvent",
      "PubSub::ActiveRecord::Events::BeforeSaveEvent",
      "PubSub::ActiveRecord::Events::BeforeCreateEvent",
      "PubSub::ActiveRecord::Events::AfterCreateEvent",
      "PubSub::ActiveRecord::Events::AfterSaveEvent",
      "PubSub::ActiveRecord::Events::AfterRollbackEvent",
      "PubSub::ActiveRecord::Events::AfterCreateRollbackEvent"
    ])
  end

  it "reports changes" do
    @test_model_class.add_subscriber(@test_subscriber)
    instance = @test_model_class.create!(name: "test")
    instance.update!(name: "test2")

    # rollbacks don't get reported
    @test_model_class.transaction do
      @test_model_class.create!(name: "test")
      raise ActiveRecord::Rollback
    end

    instance.destroy!

    @test_subscriber.received.select! do |event|
      [
        "PubSub::ActiveRecord::Events::CreateChangeEvent",
        "PubSub::ActiveRecord::Events::UpdateChangeEvent",
        "PubSub::ActiveRecord::Events::DestroyChangeEvent"
      ].include?(event.class.name)
    end

    expect(@test_subscriber.received.map { |event| event.class.name }).to eq([
      "PubSub::ActiveRecord::Events::CreateChangeEvent",
      "PubSub::ActiveRecord::Events::UpdateChangeEvent",
      "PubSub::ActiveRecord::Events::DestroyChangeEvent"
    ])
    expect(@test_subscriber.received.map { |event| event.payload[:changes] }).to eq([
      {"id"=>[nil, 4], "name"=>[nil, "test"]},
      {"name"=>["test", "test2"]},
      nil
    ])
  end
end
