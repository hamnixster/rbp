module Bookmark
  class Base
    attr_reader :id, :operation, :source, :notices, :command, :parser, :hosting_section

    def initialize(
      id, parser, source, hosting_section,
      command: nil,
      operation: nil,
      tags: [],
      options: {}
    )
      @id = id
      @parser = parser
      @source = source
      @hosting_section = hosting_section

      @command = command
      @operation = operation

      @tags = tags
      @options = options
    end

    def all
      []
    end

    def input
      @input = source.input.to_s
    end

    # not sure this should work unless we are folder backed
    def to_s(parent: nil, child: nil)
      if source.input.instance_of?(Pathname)

        if @hosting_section&.source&.input&.dirname == source.input.dirname
          parent ||= 0
          child ||= 0
        elsif @hosting_section
          parent ||= @hosting_section.source.input.dirname.ascend.to_a.index { |i| i.to_s == source.input.dirname.to_s }
          child ||= source.input.dirname.ascend.to_a.index { |i| i.to_s == @hosting_section.source.input.dirname.to_s }
          parent ||= 0
          child ||= 0
        end
        input_str =
          if parent.nil?
            input
          elsif parent.zero?
            input.split("/").last
          else
            ("../" * parent) + input.gsub(/\.\.\//, "").split("/").last
          end
        if child && !child.zero?
          input_str =
            input.to_s.reverse.split("/")[1..child]
              .map(&:reverse).reverse.join("/") + "/" + input_str.split("/").last
        end

        input_str = input_str.sub(/\.rbp$/, "")
      end

      input_str ||= input

      options = @options.map { |k, v| "-#{k} #{v}" }.join(" ")
      [@command, input_str, options].join(" ").strip
      # puts "#{child} #{parent} #{output}"
    end

    def execute(**kwargs)
      Dir.chdir(source.dirname)
      @operation&.call(self, **kwargs)
    end

    def valid?
      source&.try_touch && parser && operation && true
    end

    def ==(other)
      id.strip == other.id.strip && source.input.to_s.strip == other.source.input.to_s.strip
    end
  end
end
