require_relative "publisher.rb"
require_relative "subscriber.rb"

module PubSub
  def self.event_bus
    Module.new do
      include PubSub.subscriber
      include PubSub.publisher
    end
  end
end