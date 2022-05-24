module PubSub
  def self.subscriber
    Module.new do
      def on_event(_event)
        raise "no implementation"
      end
    end
  end
end