require "./lib/bookmark/base"
require "./lib/bookmark/section"

module Bookmark
  def self.type(operation)
    Rbp::Container["config.operation_bookmark_map"].fetch(operation, ::Bookmark::Base)
  end
end
