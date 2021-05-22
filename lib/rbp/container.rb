require "dry/system/container"
require "fileutils"
require "open3"
require "pathname"

require "./lib/rofi"

require "./lib/bookmark"
require "./lib/parser"
require "./lib/repository"
require "./lib/operation"
require "./lib/source"

BASE = File.expand_path("~/.cache/rbp/")

module Rbp
  class Container < Dry::System::Container
    configure do |config|
      config.root = Pathname("./lib/rbp")
    end
  end
end

Rbp::Container.register("source.file", Source::File)
Rbp::Container.register("source.literal", Source::Literal)

Rbp::Container.register("parser.line", Parser::Bookmark::Line.new)
Rbp::Container.register("parser.section.folder", Parser::Section::Folder.new(BASE))

Rbp::Container.register("operation.rbp", Operation::Rbp.new)

Rbp::Container.register(
  "config.operation_bookmark_map",
  {"rbp" => ::Bookmark::Section}
)

Rbp::Container.register(
  "repository.section.folder",
  Repository::Section.new(
    Rbp::Container["parser.section.folder"],
    Rbp::Container["source.file"],
    directory: BASE,
    location: "#{BASE}/sections"
  )
)
