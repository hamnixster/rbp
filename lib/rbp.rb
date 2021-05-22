require "open3"

require "./lib/bookmark"
require "./lib/rofi"

require "./lib/application_parser"
require "./lib/line_parser"

require "./lib/application_repository"
require "./lib/section_repository"
# require "./lib/operation_repository"
# require "./lib/command_repository"

class Rbp
  PARSER = LineParser.new # @type const PARSER: ApplicationParser
  REPOSITORIES = {
    section: SectionRepository.new(PARSER)
  } # @type const REPOSITORIES: Hash[Symbol, ApplicationRepository]

  def self.main(section_name)
    command = yield(section_name, REPOSITORIES[:section].find(section_name))
    true
  end
end
