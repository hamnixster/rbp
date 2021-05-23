module Repository
  class Section
    def initialize(parser, source, location: nil, directory: nil)
      @location = location
      @source = source.new(location)
      @parser = parser
    end

    def find(id)
      entries.find { |item| item.id == id }
    end

    def find_or_create(id)
      find(id) ||
        (
          @source << id
          @parser.call(id)
        )
    end

    private

    def entries
      @entries ||= @source.all.map { |id| @parser.call(id) unless id.empty? }.compact
    end
  end
end
