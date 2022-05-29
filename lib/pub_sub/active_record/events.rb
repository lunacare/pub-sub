require_relative "../base_event.rb"

module PubSub
  module ActiveRecord
    module Events
      class CallbackEvent < PubSub::BaseEvent
        def initialize(payload)
          super({ timestamp: Time.now(), **payload })
        end
      end

      class AfterInitializeEvent < CallbackEvent
      end

      class AfterFindEvent < CallbackEvent
      end

      class AfterFindEvent < CallbackEvent
      end

      class AfterTouchEvent < CallbackEvent
      end

      class BeforeValidationEvent < CallbackEvent
      end

      class AfterValidationEvent < CallbackEvent
      end

      class BeforeSaveEvent < CallbackEvent
      end

      class AfterSaveEvent < CallbackEvent
      end

      class BeforeCreateEvent < CallbackEvent
      end

      class AfterCreateEvent < CallbackEvent
      end

      class BeforeUpdateEvent < CallbackEvent
      end

      class AfterUpdateEvent < CallbackEvent
      end

      class BeforeDestroyEvent < CallbackEvent
      end

      class AfterDestroyEvent < CallbackEvent
      end

      class AfterCommitEvent < CallbackEvent
      end

      class AfterCreateCommitEvent < AfterCommitEvent
      end

      class AfterUpdateCommitEvent < AfterCommitEvent
      end

      class AfterDestroyCommitEvent < AfterCommitEvent
      end

      class AfterRollbackEvent < CallbackEvent
      end

      class AfterCreateRollbackEvent < AfterRollbackEvent
      end

      class AfterUpdateRollbackEvent < AfterRollbackEvent
      end

      class AfterDestroyRollbackEvent < AfterRollbackEvent
      end

      class ChangeEvent < PubSub::BaseEvent
        def initialize(payload)
          super({ timestamp: Time.now(), **payload })
        end
      end

      class CreateChangeEvent < ChangeEvent
      end

      class UpdateChangeEvent < ChangeEvent
      end

      class DestroyChangeEvent < ChangeEvent
      end
    end
  end
end
