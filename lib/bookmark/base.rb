module Bookmark
  class Base
    attr_reader :id, :input, :directory, :operation

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
      @operation = operation
      @input = input

      @directory = directory
      @tags = tags

      @location = location || Pathname.new(File.join(directory, input))
      @source = source.new(location || input)
    end

    def all
      []
    end

    def to_s
      id
    end

    def execute
      @operation&.call(self)
    end

    def operation=(operation)
      @operation = operation
      @location = (@input && @operation.location(@input, location: @location)) || @location
      @parser = @operation.parser(@input, @directory)
      @source = @operation.source(@location)
      @command = operation.command
    end
  end
end
