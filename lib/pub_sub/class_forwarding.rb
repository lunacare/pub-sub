module PubSub
  module ClassForwarding
    def initialize(...)
      add_subscriber(self.class)
      super(...)
    end
  end
end
