module PubSub
  def self.publisher
    Module.new do
      alias :add_subscriber :add_subscribers
      alias :remove_subscriber :remove_subscribers
      alias :yeet_subscriber :remove_subscriber

      def add_subscribers(*subscribers_to_add)
        subscribers.merge(subscribers_to_add)
        nil
      end

      def remove_subscribers(*subscribers_to_remove)
        subscribers.subtract(subscribers_to_add)
        nil
      end
  
      private
  
      def broadcast(event)
        subscribers.each { |subscriber| subscriber.on_event(event) }
      end

      def subscribers
        @subscribers ||= Set[]
      end
    end
  end
end