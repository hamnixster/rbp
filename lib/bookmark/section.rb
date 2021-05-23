module Bookmark
  class Section < Base
    def all
      entries
    end

    def find(to_s)
      entries.find { |e| e.to_s == to_s }
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
      @entries ||=
        @source.tap { |s| s.try_touch }
          .all.map { |id| @parser.call(id, hosting_section: self) }
          .compact
    end
  end
end
