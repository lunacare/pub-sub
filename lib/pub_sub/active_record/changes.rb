require_relative "../subscriber.rb"
require_relative "../publisher.rb"
require_relative "events.rb"

module PubSub
  module ActiveRecord
    module Changes
      def self.extended(base)
        base.class_eval do
          def self.changes_event_bus
            @changes_event_bus ||= Class.new do
              include PubSub::Subscriber
              include PubSub::Publisher

              on(Events::AfterCreateCommitEvent) do |event|
                broadcast(Events::CreateChangeEvent.new({
                  timestamp: event.payload[:record].try(:updated_at) || Time.now(),
                  id: event.payload[:record].id,
                  changes: event.payload[:record].previous_changes
                }))
              end

              on(Events::AfterUpdateCommitEvent) do |event|
                broadcast(Events::UpdateChangeEvent.new({
                  timestamp: event.payload[:record].try(:updated_at) || Time.now(),
                  id: event.payload[:record].id,
                  changes: event.payload[:record].previous_changes
                }))
              end

              on(Events::AfterDestroyCommitEvent) do |event|
                broadcast(Events::DestroyChangeEvent.new({
                  timestamp: event.payload[:record].try(:updated_at) || Time.now(),
                  id: event.payload[:record].id,
                }))
              end
            end.new
          end

          add_subscriber(changes_event_bus)
        end
      end
    end
  end
end
