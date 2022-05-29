require_relative "subscriber.rb"
require_relative "publisher.rb"

module PubSub
  module Bus
    def self.included(base)
      base.include PubSub::Subscriber
      base.include PubSub::Publisher
    end

    def self.extended(base)
      base.extend PubSub::Subscriber
      base.extend PubSub::Publisher
    end
  end
end
