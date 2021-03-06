require "set"

module PubSub
  module Publisher
    def add_subscribers(*subscribers_to_add)
      subscribers.merge(subscribers_to_add)
      nil
    end

    def remove_subscribers(*subscribers_to_remove)
      subscribers.subtract(subscribers_to_remove)
      nil
    end

    alias :add_subscriber :add_subscribers
    alias :remove_subscriber :remove_subscribers
    alias :yeet_subscribers :remove_subscribers
    alias :yeet_subscriber :yeet_subscribers

    private

    def broadcast(event)
      subscribers.each { |subscriber| subscriber.on_event(event) }
      nil
    end

    def subscribers
      @subscribers ||= Set[]
    end
  end
end
