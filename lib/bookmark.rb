class Bookmark
  def initialize(name:, command:, operation:, directory: Dir.home, tags: [])
    @name = name
    @command = command
    @operation = operation
    @directory = directory
    @tags = tags
  end
end
