require "polyglot"
require "treetop"
Treetop.load "./lib/grammar/line"

module Parser
  module Bookmark
    class Line
      def parse_options(option, options: {})
        next_option, words = option.next_option.elements
          .partition { |n| n.extension_modules.any? { |em| em == ::Line::Option0 } }
        options[option.section.text_value] = words.map(&:text_value).join
        next_option = next_option.first
        if next_option
          parse_options(next_option, options: options)
        else
          options
        end
      end

      def call(line, hosting_section: nil)
        return if line.strip.empty?
        line_parser = LineParser.new
        result = line_parser.parse(line)
        unless result
          ::Rbp::Container["operation.rbp.messages"] << line_parser.failure_reason
          ::Rbp::Container["operation.rbp.messages"] << line_parser.failure_column.to_s
          return
        end
        command, input = result.elements.map(&:text_value).map(&:strip)

        options =
          if result.next_option.extension_modules&.any? { |em| em == ::Line::Option0 }
            parse_options(result.next_option)
          elsif result.next_option.elements.last.extension_modules&.any? { |em| em == ::Line::Option0 }
            input =
              result.next_option.elements
                .reject { |n| n.extension_modules.any? { |em| em == ::Line::Option0 } }
                .map(&:text_value).join
            parse_options(result.next_option.elements.last)
          else
            input = result.next_option.elements.map(&:text_value).join.strip
            {}
          end

        if (string = result.elements.find { |e| e.respond_to?(:string) }&.string)
          input = string.text_value[1...-1]
        end

        source_type =
          if options["st"]
            if Rbp::Container.key?("source.#{options["st"]}")
              Rbp::Container["source.#{options["st"]}"]
            else
              Rbp::Container["source.literal"]
            end
          elsif Rbp::Container.key?("operation.rbp") && Rbp::Container["operation.rbp"] && command == "rbp"
            hosting_section&.source.class
          else
            Rbp::Container["source.literal"]
          end

        input = input.strip

        # try parse the parser, for now always line
        parser ||= Rbp::Container["parser.line"]

        if Rbp::Container.key?("operation.#{command}")
          operation = Rbp::Container["operation.#{command}"]
          command = operation.command
        else
          operation = nil
        end

        bookmark_type = operation&.bookmark_type || ::Bookmark::Base

        source = source_type.new(input, hosting_section: hosting_section, operation: operation)

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
