require_relative "bus.rb"
require_relative "publisher.rb"
require_relative "class_forwarding.rb"

class TestCase
  extend PubSub.bus
  include PubSub.publisher
  prepend PubSub.class_forwarding

  def initialize(*args)
    p "args:", args
  end

  def do_something(thing)
    broadcast(thing)
  end

  def self.on_event(event)
    p "handling that shit", event
  end
end