class LineParser < ApplicationParser
  def call(line)
    Bookmark.new(name: "", command: nil, operation: nil)
  end
end
