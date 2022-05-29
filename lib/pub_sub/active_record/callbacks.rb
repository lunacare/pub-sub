require_relative "../bus.rb"
require_relative "../publisher.rb"
require_relative "../class_forwarding.rb"
require_relative "events.rb"

module PubSub
  module ActiveRecord
    module Callbacks
      def self.included(base)
        base.class_eval do
          after_initialize     :broadcast_after_initialize
          after_find           :broadcast_after_find
          after_touch          :broadcast_after_touch

          before_validation    :broadcast_before_validation
          after_validation     :broadcast_after_validation

          before_save          :broadcast_before_save
          after_save           :broadcast_after_save

          before_create        :broadcast_before_create
          after_create         :broadcast_after_create

          before_update        :broadcast_before_update
          after_update         :broadcast_after_update

          before_destroy       :broadcast_before_destroy
          after_destroy        :broadcast_after_destroy

          after_commit         :broadcast_after_create_commit, on: :create
          after_commit         :broadcast_after_update_commit, on: :update
          after_commit         :broadcast_after_destroy_commit, on: :destroy

          after_rollback       :broadcast_after_create_rollback, on: :create
          after_rollback       :broadcast_after_update_rollback, on: :update
          after_rollback       :broadcast_after_destroy_rollback, on: :destroy

          def broadcast_after_initialize
            broadcast_callback_event(Events::AfterInitializeEvent)
          end
    
          def broadcast_after_find
            broadcast_callback_event(Events::AfterFindEvent)
          end
    
          def broadcast_after_touch
            broadcast_callback_event(Events::AfterTouchEvent)
          end
    
          def broadcast_before_validation
            broadcast_callback_event(Events::BeforeValidationEvent)
          end
    
          def broadcast_after_validation
            broadcast_callback_event(Events::AfterValidationEvent)
          end
    
          def broadcast_before_save
            broadcast_callback_event(Events::BeforeSaveEvent)
          end
    
          def broadcast_after_save
            broadcast_callback_event(Events::AfterSaveEvent)
          end

          def broadcast_before_create
            broadcast_callback_event(Events::BeforeCreateEvent)
          end
    
          def broadcast_after_create
            broadcast_callback_event(Events::AfterCreateEvent)
          end

          def broadcast_before_update
            broadcast_callback_event(Events::BeforeUpdateEvent)
          end
    
          def broadcast_after_update
            broadcast_callback_event(Events::AfterUpdateEvent)
          end
    
          def broadcast_before_destroy
            broadcast_callback_event(Events::BeforeDestroyEvent)
          end
    
          def broadcast_after_destroy
            broadcast_callback_event(Events::AfterDestroyEvent)
          end
    
          def broadcast_after_create_commit
            broadcast_callback_event(Events::AfterCommitEvent)
            broadcast_callback_event(Events::AfterCreateCommitEvent)
            broadcast(Events::CreateChangeEvent.new({
              timestamp: self.try(:updated_at) || Time.now(),
              id: self.id,
              changes: self.previous_changes
            }))
          end
    
          def broadcast_after_update_commit
            broadcast_callback_event(Events::AfterCommitEvent)
            broadcast_callback_event(Events::AfterUpdateCommitEvent)
            broadcast(Events::UpdateChangeEvent.new({
              timestamp: self.try(:updated_at) || Time.now(),
              id: self.id,
              changes: self.previous_changes
            }))
          end
    
          def broadcast_after_destroy_commit
            broadcast_callback_event(Events::AfterCommitEvent)
            broadcast_callback_event(Events::AfterDestroyCommitEvent)
            broadcast(Events::DestroyChangeEvent.new({
              timestamp: self.try(:updated_at) || Time.now(),
              id: self.id,
            }))
          end

          def broadcast_after_create_rollback
            broadcast_callback_event(Events::AfterRollbackEvent)
            broadcast_callback_event(Events::AfterCreateRollbackEvent)
          end
    
          def broadcast_after_update_rollback
            broadcast_callback_event(Events::AfterRollbackEvent)
            broadcast_callback_event(Events::AfterUpdateRollbackEvent)
          end
    
          def broadcast_after_destroy_rollback
            broadcast_callback_event(Events::AfterRollbackEvent)
            broadcast_callback_event(Events::AfterDestroyRollbackEvent)
          end
    
          private
    
          def broadcast_callback_event(event_class)
            broadcast(event_class.new({ record: self }))
            nil
          end
        end
      end
    end
  end
end
