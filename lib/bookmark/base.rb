module Bookmark
  class Base
    attr_reader :id, :input, :operation, :source, :notices, :command, :parser

    def initialize(
      id, parser, source,
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

      @notices = []
    end

    def all
      []
    end

    # not sure this should work unless we are folder backed
    def to_s(parent: nil, child: nil)
      input =
        if parent.nil?
          @input
        elsif parent.zero?
          @input.split("/").last
        else
          ("../" * parent) + @input.gsub(/\.\.\//, "")
        end
      if child && !child.zero?
        input =
          source.input.to_s.reverse.split("/")[1..child]
            .map(&:reverse).reverse.join("/") + "/" + input.split("/").last
      end
      [@command, input].join(" ")
    end

    def execute(**kwargs)
      @operation&.call(self, **kwargs)
    end

    def valid?
      source&.try_touch && parser && operation && true
    end
  end
end
