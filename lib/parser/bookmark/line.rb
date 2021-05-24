module Parser
  module Bookmark
    class Line
      def call(line, hosting_section: nil)
        return if line.strip.empty?
        command, input = line.split(" ", 2)
        input ||= ""
        source_type =
          if Rbp::Container.key?("operation.rbp") && Rbp::Container["operation.rbp"] && command == "rbp"
            hosting_section&.source.class
          elsif false
            # try parse the source type from string
          else
            Rbp::Container["source.literal"]
          end

        # try parse the parser, for now always line
        parser ||= Rbp::Container["parser.line"]

        if Rbp::Container.key?("operation.#{command}")
          operation = Rbp::Container["operation.#{command}"]
          command = operation.command
        else
          operation = nil
        end

        bookmark_type = operation&.bookmark_type || ::Bookmark::Base

        source = source_type.new(input, hosting_section: hosting_section)

        return unless operation
        bookmark_type.new(
          line, parser, source,
          command: command,
          input: input,
          operation: operation
        )
      end
    end
  end
end
