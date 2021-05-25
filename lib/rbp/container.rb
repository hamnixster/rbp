require "dry/system/container"
require "fileutils"
require "open3"
require "pathname"

require "./lib/rofi"

require "./lib/bookmark"
require "./lib/rbp_parser"
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

Rbp::Container.register("parser.line", RbpParser::Bookmark::Line.new)
