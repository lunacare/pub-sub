require_relative "active_record/model.rb"
require_relative "bus.rb"
require_relative "publisher.rb"
require_relative "class_forwarding.rb"
require_relative "event.rb"

class TestEvent < PubSub::Event
end

class TestModel
  extend PubSub::ActiveRecord::Model

  def do_something
    broadcast(TestEvent.new("this was a payload"))
  end
end

class TestLogger
  include PubSub::Subscriber

  def on_event(event)
    p event.payload
  end
end