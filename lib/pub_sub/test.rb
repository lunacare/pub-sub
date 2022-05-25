require_relative "bus.rb"
require_relative "publisher.rb"
require_relative "class_forwarding.rb"

class TestCase
  extend PubSub::Bus
  include PubSub::Publisher
  prepend PubSub::ClassForwarding

  def do_something(thing)
    broadcast(thing)
  end
end