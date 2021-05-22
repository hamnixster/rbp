require 'delegate'

module Source
  class Base < SimpleDelegator
    attr_reader :input

    def initialize(input)
      @input = input
    end
  end
end
