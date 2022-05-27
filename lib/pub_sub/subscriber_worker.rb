require "sidekiq"
require "yaml"

module PubSub
  class SubscriberWorker
    include Sidekiq::Worker
    extend PubSub::Subscriber

    sidekiq_options retry: false

    class << self
      alias :on_event_sync :on_event

      def on_event(event)
        perform_async({
          "event_class_name" => event.class.name,
          "payload" => event.payload
        })
      end
    end

    def perform(args)
      self.class.on_event_sync(Object.const_get(args["event_class_name"]).new(args["payload"]))
    end
  end
end
