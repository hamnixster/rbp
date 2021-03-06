require "polyglot"
require "treetop"
Treetop.load "./lib/grammar/line"

module RbpParser
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

        options = options.map { |k, v| [k.to_sym, v] }.to_h

        if (string = result.elements.find { |e| e.respond_to?(:string) }&.string)
          input = string.text_value[1...-1]
          input.gsub!(/\\"/, '"')
        # This is the case that the only provided element is quoted
        elsif result.elements.count == 3 &&
              (string = result.elements.last) &&
              [string.text_value[0], string.text_value[-1]].all? { |q| q == "\""}
          input = string.text_value[1...-1]
          input.gsub!(/\\"/, '"')
        end

        source_type =
          if options["st"] && Rbp::Container.key?("source.#{options["st"]}")
            Rbp::Container["source.#{options["st"]}"]
          elsif Rbp::Container.key?("operation.rbp") && Rbp::Container["operation.rbp"] && command == "rbp"
            hosting_section&.source.class
          else
            Rbp::Container["source.literal"]
          end

        input = input.strip

        # try parse the parser, for now always line
        parser ||= Rbp::Container["parser.line"]

        operation = get_operation(command, options)

        command = operation&.command

        bookmark_type = operation&.bookmark_type || ::Bookmark::Base

        source = source_type.new(input, hosting_section: hosting_section, operation: operation)

        return unless operation
        bookmark_type.new(
          line, parser, source, hosting_section,
          command: command,
          operation: operation,
          options: options
        )
      end

      def get_operation(command, options)
        if Rbp::Container.key?("operation.#{command}")
          if Rbp::Container["operation.#{command}"].is_a?(Class)
            if options[:w]
              first, rest = options[:w].split(" ", 2)
              operation = get_operation(first, options.merge(w: rest))
              Rbp::Container["operation.#{command}"].new(command, w: operation)
            else
              Rbp::Container["operation.#{command}"].new(command)
            end
          else
            Rbp::Container["operation.#{command}"]
          end
        end
      end
    end
  end
end
