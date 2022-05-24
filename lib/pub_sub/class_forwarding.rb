module PubSub
  def self.class_forwarding
    Module.new do
      def initialize(...)
        p "in initialize"
        add_subscriber(self.class)
        p "doing base initialize"
        super(...)
      end
    end
  end
end
