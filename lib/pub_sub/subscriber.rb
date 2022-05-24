require_relative "registry"

module PubSub
  def self.subscriber
    Module.new do
      def on_event(event)
        raise "no implementation"
      end
    end
  end
end