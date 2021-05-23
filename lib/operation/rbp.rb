module Operation
  class Rbp < Base
    def call(section = nil)
      command = Rofi.call(section.to_s, THEME, section.all)
      selection = Parser::Bookmark::Line.new.call(command, directory: section.directory || BASE)
      selection&.execute
      true
    end

    def parser(input = nil, directory = nil)
      input ||= "base"
      if ::Rbp::Container.key?("parser.section.folder.#{input}")
        ::Rbp::Container["parser.section.folder.#{input}"]
      else
        ::Rbp::Container.register(
          "parser.section.folder.#{input}",
          Parser::Section::Folder.new(BASE)
        )
      end
    end

    def source(location = "")
      ::Rbp::Container["source.file"].new(location)
    end
  end
end
