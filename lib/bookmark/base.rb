module Bookmark
  class Base
    attr_reader :id, :input

    def initialize(
      id, parser, source,
      location: nil,
      command: nil,
      input: nil,
      operation: nil,
      directory: BASE,
      tags: []
    )
      @id = id
      @parser = parser
      @command = command
      @location = location
      @operation = operation
      @input = input

      @directory = directory
      @tags = tags

      @source = source.new(location || input)
    end

    def all
      []
    end

    def to_s
      id
    end

    def execute
      @operation.call(self) if @operation
    end

    def set_operation(command)
      if Rbp::Container.key?("operation.#{command}")
        @operation = Rbp::Container["operation.#{command}"]
        @location = @operation.location(@input) if @input
        @parser = @operation.parser
        @source = @operation.source(@location)
        @command = command
      end
    end
  end
end
