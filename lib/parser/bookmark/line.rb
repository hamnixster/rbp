module Parser
  module Bookmark
    class Line
      def call(line, hosting_section: nil)
        return if line.strip.empty?
        command, input = line.split(" ")
        input ||= ""
        # i guess we will also prefer parsing in the source type here somehow
        source_type = hosting_section&.source.class || Rbp::Container["source.literal"]
        # same with parser, for now always line
        parser ||= Rbp::Container["parser.line"]

        if Rbp::Container.key?("operation.#{command}")
          operation = Rbp::Container["operation.#{command}"]
          command = operation.command
        else
          operation = nil
        end

        bookmark_type = operation&.bookmark_type || ::Bookmak::Base

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
