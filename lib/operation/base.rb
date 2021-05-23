module Operation
  class Base
    attr_reader :command

    def initialize(command)
      @command = command
      ::Rbp::Container.register("operation.#{command}", self)
    end

    def bookmark_type
      nil
    end
  end
end
