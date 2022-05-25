require_relative "../bus.rb"
require_relative "../publisher.rb"
require_relative "../class_forwarding.rb"

module PubSub
  module ActiveRecord
    module Model
      def self.extended(base)
        base.extend PubSub::Bus
        base.include PubSub::Publisher
        base.prepend PubSub::ClassForwarding
      end
    end
  end
end
