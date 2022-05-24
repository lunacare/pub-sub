require_relative "registry"

module PubSub
  def self.publisher
    Module.new do
      def subscribe(subscriber)
        subscribers.add(subscriber)
      end
  
      def unsubscribe(subscriber)
        subscribers.delete(subscriber)
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