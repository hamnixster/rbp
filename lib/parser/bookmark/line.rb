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
          location: Pathname.new(File.join(directory, input || "")),
          directory: Pathname.new(File.join(directory, input || "")).dirname
        ).tap do |bm|
          if Rbp::Container.key?("operation.#{command}")
            bm.operation = Rbp::Container["operation.#{command}"]
          end
        end
      end
    end
  end
end
