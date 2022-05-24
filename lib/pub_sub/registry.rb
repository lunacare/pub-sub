require "singleton"

module PubSub
  class Registry
    include ::Singleton

    def register_subscriber(name, subscriber)
      subscribers[name] ||= subscriber
    end

    def register_publisher(name, publisher)
      publishers[name] ||= publisher
    end

    def register_signal(publisher_name, subscriber_name)
      signals[publisher_name] ||= Set[]
      signals[publisher_name] << subscriber_name
      nil
    end

    def unregister_subscriber(name)
      subscribers.delete(name)
    end

    def unregister_publisher(name)
      publishers.delete(name)
    end

    def unregister_signal(publisher_name, subscriber_name)
      signals[publisher_name].delete(subscriber_name)
    end

    def publishers
      @publishers ||= {}
    end

    def subscribers
      @subscribers ||= {}
    end

    def signals
      @signals ||= {}
    end
  end
end