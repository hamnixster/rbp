require "dry/system/container"
require "fileutils"
require "open3"
require "pathname"

require "./lib/rofi"

require "./lib/bookmark"
require "./lib/parser"
require "./lib/operation"
require "./lib/source"

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

Rbp::Container.register("operation.rbp", Operation::Rbp.new("rbp"))

Rbp::Container.register(
  "config.operation_bookmark_map",
  {"rbp" => ::Bookmark::Section}
)

Rbp::Container.register(
  "main-section",
  Bookmark::Section.new(
    "rbp main",
    Rbp::Container["parser.line"],
    Rbp::Container["source.file"].new(Pathname.new("#{BASE}/main")),
    location: Pathname.new("#{BASE}/main"),
    operation: Rbp::Container["operation.rbp"]
  )
)
