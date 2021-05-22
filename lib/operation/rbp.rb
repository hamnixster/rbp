module Operation
  class Rbp < Base
    def call(section = nil)
      command = Rofi.call(section.to_s, THEME, section.all)
      selection = Parser::Bookmark::Line.new.call(command)
      selection&.execute
      true
    end

    def parser
      ::Rbp::Container["parser.section.folder"]
    end

    def source(location = "")
      ::Rbp::Container["source.file"].new(location)
    end

    def location(name)
      @location = name
      parser.base_folder.join(name)
    end
  end
end
