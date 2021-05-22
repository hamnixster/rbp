module Parser
  module Section
    class Folder
      attr_reader :base_folder

      def initialize(base_folder)
        @base_folder = Pathname.new(base_folder)
      end

      def call(line)
        section = Rbp::Container["parser.line"].call(line)
        location = Pathname.new(@base_folder + section.input)
        FileUtils.mkdir_p(location.dirname)
        ::Bookmark::Section.new(
          section.to_s,
          Rbp::Container["parser.line"],
          Rbp::Container["source.file"],
          location: location
        )
      end
    end
  end
end
