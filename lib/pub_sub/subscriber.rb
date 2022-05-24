require_relative "registry"

module PubSub
  def self.subscriber(pub_sub_options = {})
    Module.new do
      def self.included(klass)
        Registry.instance.register_subscriber(pub_sub_options[:id] || klass.object_id, klass)
      end

      def self.extended(klass)
        Registry.instance.register_subscriber(pub_sub_options[:id] || klass.object_id, klass)
      end

      def pub_sub_id
        pub_sub_options[:id] || klass.object_id
      end

      def on_event(event)
        raise "Awaiting implementation"
      end
    end
  end
end