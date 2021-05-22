module Bookmark
  class Section < Base
    def all
      entries
    end

    def find(to_s)
      entries.find { |e| e.to_s == to_s }
    end

    private

    def entries
      @entries ||= @source.tap { |s| s.try_touch }.all.map { |id| @parser.call(id) }
    end
  end
end
