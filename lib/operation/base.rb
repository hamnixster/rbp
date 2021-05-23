module Operation
  class Base
    attr_reader :command

    def initialize(command)
      @command = command
    end

    def parser
      nil
    end

    def source
      nil
    end

    def location(*_args, **_kwargs)
      nil
    end
  end
end
