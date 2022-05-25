require_relative "base_event.rb"

module PubSub
  module Subscriber
    def self.included(base)
      base.class.define_method :event_handlers do
        @@event_handlers ||= {}
      end

      base.class.define_method :on do |*event_classes, &block|
        event_classes.each do |event_class|
          base.class.event_handlers[event_class] = block
        end
      end
    end

    def on_event(event)
      event_handler = self.class.event_handlers[event.class]

      if event_handler.nil?
        on_unhandled_event(event)
      else
        event_handler.call(event)
      end

      nil
    end

    def on_unhandled_event(event)
    end
  end
end
