module Source
  class Base
    attr_reader :input, :dirname

    def initialize(input, **kwargs)
      @input = input
      @dirname = kwargs[:hosting_section].source.dirname
    end

    def try_touch
      true
    end

    def all
      @all ||= []
    end

    def <<(item)
      @all << item
    end
  end
end
