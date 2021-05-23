module Bookmark
  class Base
    attr_reader :id, :input, :operation, :source, :location

    def initialize(
      id, parser, source,
      location: nil,
      command: nil,
      input: nil,
      operation: nil,
      tags: []
    )
      @id = id
      @parser = parser
      @source = source

      @command = command
      @operation = operation
      @input = input

      @tags = tags

      @location = location || Pathname.new(File.join(directory, input))
    end

    def all
      []
    end

    def to_s
      id
    end

    def directory
      @location.dirname
    end

    def execute
      @operation&.call(self)
    end

    def operation=(operation)
      @operation = operation
      @location = (@input && @operation.location(@input, location: @location)) || @location
      @parser = @operation.parser
      @source = @operation.source(@location)
      @command = operation.command
    end
  end
end
