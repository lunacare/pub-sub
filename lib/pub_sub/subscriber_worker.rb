require "json"

module PubSub
  module AsyncSubscriber
    def self.included(base)
      raise "AsyncSubscriber doesn't support being included. It must be extended."
    end

    def self.extended(base)
      base.extend PubSub::Subscriber

      base.class_eval do
        class << self
          alias :on_event_sync :on_event
    
          def on_event(event)
            perform_async(JSON.dump({
              "event_class_name" => event.class.name,
              "payload" => event.payload
            }))
          end
        end

        def perform(serialized_args)
          args = JSON.parse(serialized_args)
          self.class.on_event_sync(Object.const_get(args["event_class_name"]).new(args["payload"]))
        end
      end
    end
  end
end
