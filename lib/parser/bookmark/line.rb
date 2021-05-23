module Parser
  module Bookmark
    class Line
      def call(line, hosting_section: nil, directory: nil)
        return if line.strip.empty?
        command, input = line.split(" ")
        input ||= ""

        if Rbp::Container.key?("operation.#{command}")
          operation = Rbp::Container["operation.#{command}"]
          parser = operation.parser
          command = operation.command
        else
          parser = Rbp::Container["parser.line"]
          operation = nil
        end
        location = Pathname.new(File.join(directory || hosting_section.location.dirname, input || "")) ||
          (input && operation.location(input))
        source ||= operation&.source(location) || Rbp::Container["source.literal"].new(location)

        ::Bookmark.type(command).new(
          line, parser, source,
          command: command,
          input: input,
          location: location,
          operation: operation
        )
      end
    end
  end
end
