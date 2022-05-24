require 'ostruct'

module PubSub
  class Event < OpenStruct
    def initialize(*args)
      super
      freeze
    end
  end
end
