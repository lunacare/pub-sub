require_relative "../bus.rb"
require_relative "../publisher.rb"
require_relative "../class_forwarding.rb"
require_relative "changes.rb"
require_relative "callbacks.rb"

module PubSub
  module ActiveRecord
    module Model
      def self.extended(base)
        base.extend PubSub::Bus
        base.extend PubSub::ActiveRecord::Changes
        base.include PubSub::Publisher
        base.prepend PubSub::ClassForwarding
        base.include PubSub::ActiveRecord::Callbacks
      end
    end
  end
end
