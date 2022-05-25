require_relative "base_event.rb"

module PubSub
  module Subscriber
    def self.included(base)
      base.class.define_method :on do |event_class, &block|
        base.define_method "on_#{event_class.name}" do |event|
          block.call(event)
        end
      end
    end

    def on_event(event)
      if event.is_a?(PubSub::BaseEvent) && self.respond_to?("on_#{event.class.name}")
        self.send("on_#{event.class.name}", event)
      else
        on_unhandled_event(event)
      end

      nil
    end

    def on_unhandled_event(event)
    end
  end
end