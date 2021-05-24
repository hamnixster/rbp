module Operation
  class Base
    attr_reader :command

    def self.register(command)
      instance = new(command)
      ::Rbp::Container.register("operation.#{command}", instance)
      instance
    end

    def initialize(command, **kwargs)
      @command = command
    end

    def bookmark_type
      nil
    end
  end
end
