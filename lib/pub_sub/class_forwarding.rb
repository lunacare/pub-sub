module PubSub
  def self.class_forwarding
    Module.new do
      def initialize(...)
        add_subscriber(self.class)
        super(...)
      end
    end
  end
end
