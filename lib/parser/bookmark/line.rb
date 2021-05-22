module Parser
  module Bookmark
    class Line
      def call(line, directory: BASE)
        command, input = line.split(" ")

        parser = Rbp::Container["parser.line"]
        source = Rbp::Container["source.literal"]

        ::Bookmark.type(command).new(
          line, parser, source,
          command: command,
          input: input,
          location: directory
        ).tap { |bm| bm.set_operation(command) }
      end
    end
  end
end
