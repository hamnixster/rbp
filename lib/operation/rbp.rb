module Operation
  class Rbp < Base
    def call(section)
      command = Rofi.call(section.to_s, THEME, section.all.reject { |s| s.id == section.id })
      selection = parser.call(
        command,
        hosting_section: section,
        directory: section.directory
      )
      if (selection&.id != section.id) && selection&.operation
        section.find_or_create(selection.id)
      end
      selection&.execute
    end

    def parser
      ::Rbp::Container["parser.line"]
    end

    def source(location)
      ::Rbp::Container["source.file"].new(location)
    end

    def bookmark_class
      ::Bookmark::Section
    end
  end
end
