module PubSub
  module ActiveRecord
    module ClassForwarding
      def self.included(base)
        base.class_eval do
          after_initialize :subscribe_class

          def subscribe_class
            add_subscriber(self.class)
          end
        end
      end
    end
  end
end