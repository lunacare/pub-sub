require_relative "base_event.rb"

module PubSub
  module Subscriber
    def self.included(base)
      def base.event_handlers
        @event_handlers ||= {}
      end
      def base.on(*event_classes, &block)
        event_classes.each do |event_class|
          event_handlers[event_class] = block
        end
      end
    end

    def on_event(event)
      event_handler = self.class.event_handlers[event.class]

      if event_handler.nil?
        on_unhandled_event(event)
      else
        instance_exec(event, &event_handler)
      end

      nil
    end

    def on_unhandled_event(event)
    end
  end
end
