module Bookmark
  class Section < Base
    def all
      entries
    end

    def find(to_s)
      entries.find { |e| e.to_s == to_s }
    end

    # need to prevent accidentally writing into non-rbp files??
    # if source is a file source
    # need a better way to actually tell which entries are "the same"
    # to bookmarks need comparison operators
    def find_or_create(id)
      parsed = @parser.call(id, hosting_section: self)

      entries.find { |e| e == parsed } ||
        begin
          @source << parsed.id
          @entries = nil
        end
    end

    def remove(id)
      @source.remove(id)
    end

    def ==(other)
      id == other.id && source.input == other.source.input
    end

    private

    def entries
      @entries ||=
        @source.all.map { |id| @parser.call(id, hosting_section: self) }.compact
    end
  end
end
