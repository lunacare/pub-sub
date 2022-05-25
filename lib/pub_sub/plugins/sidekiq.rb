require "sidekiq"
require "yaml"

module PubSub
  module Plugins
    module Sidekiq
      class Worker
        include ::Sidekiq::Worker

        def perform(yml)
          (subscriber, event) = ::YAML.unsafe_load(yml)
          subscriber.on_event(event)
        end
      end

      private

      def broadcast_async(event)
        subscribers.each do |subscriber|
          Worker.perform_async(::YAML.dump([subscriber, event]))
        end
      end
    end
  end
end