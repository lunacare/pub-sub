require_relative "base_event.rb"

module PubSub
  module Subscriber
    def self.included(base)
      base.class_eval do
        def self.event_handlers
          @event_handlers ||= {}
        end
  
        def self.on(*event_classes, &block)
          event_classes.each do |event_class|
            event_handlers[event_class] = block
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

    def self.extended(base)
      base.class_eval do
        def self.event_handlers
          @event_handlers ||= {}
        end
  
        def self.on(*event_classes, &block)
          event_classes.each do |event_class|
            event_handlers[event_class] = block
          end
        end

        def self.on_event(event)
          event_handler = event_handlers[event.class]
    
          if event_handler.nil?
            on_unhandled_event(event)
          else
            event_handler.call(event)
          end
    
          nil
        end
    
        def self.on_unhandled_event(event)
        end
      end
    end
  end
end
