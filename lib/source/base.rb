module Source
  class Base
    attr_reader :input

    def initialize(input, **kwargs)
      raise "oops" unless input.respond_to?(:dirname)
      raise "oops" unless input.respond_to?(:ascend)
      @input = input
    end

    def try_touch
      true
    end
  end
end
