require_relative "registry"

module PubSub
  def self.publisher(pub_sub_options = {})
    mod = Module.new do
      # metaclass_of_dummy_class = (class << self.class; self; end)

      # metaclass_of_dummy_class.instance_eval do
      #   define_method :included do |klass|
      #     Registry.instance.register_publisher(pub_sub_options[:id] || klass.object_id, klass)
      #   end

      #   define_method :extended do |klass|
      #     Registry.instance.register_publisher(pub_sub_options[:id] || klass.object_id, klass)
      #   end
      # end

      # class << self
      #   define_method :included do |klass|
      #     Registry.instance.register_publisher(pub_sub_options[:id] || klass.object_id, klass)
      #   end

      #   define_method :extended do |klass|
      #     Registry.instance.register_publisher(pub_sub_options[:id] || klass.object_id, klass)
      #   end
      # end

      

      define_method :pub_sub_id do
        pub_sub_options[:id] || object_id
      end

      define_method :subscribe do |subscriber|
        Registry.instance.register_signal(pub_sub_id, subscriber.pub_sub_id)
      end
  
      define_method :unsubscribe do subscriber
        Registry.instance.unregister_signal(pub_sub_id, subscriber.pub_sub_id)
      end
  
      private
  
      define_method :broadcast do |event|
        Registry.signals[pub_sub_id].each do |subscriber_id|
          Registry.instance.subscribers[subscriber_id].on_event(event)
        end
      end
    end

    mod.instance_eval do
      define_method :included do |klass|
        p "included"
        Registry.instance.register_publisher(pub_sub_options[:id] || klass.object_id, klass)
      end

      define_method :extended do |klass|
        Registry.instance.register_publisher(pub_sub_options[:id] || klass.object_id, klass)
      end
    end

    mod
  end
end