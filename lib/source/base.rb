module Source
  class Base
    attr_reader :input

    def initialize(input, **kwargs)
      @input = input
    end

    def try_touch
      true
    end
  end
end
