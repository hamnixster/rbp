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
    def find_or_create(id)
      find(id) ||
        (
          @source << id
          @entries = nil
          @parser.call(id, hosting_section: self)
        )
    end

    private

    def entries
      @entries ||=
        @source.all.map { |id| @parser.call(id, hosting_section: self) }.compact
    end
  end
end
