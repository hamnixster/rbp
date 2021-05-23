require "./lib/rbp/container"

module Rbp
  class Run
    def self.main(command: nil, section: nil)
      section ||=
        Rbp::Container["repository.section.folder.base"]
          .find_or_create(command).tap { |bm| bm.operation = Rbp::Container["operation.rbp"] }

      command = section&.execute
      command&.execute if command.is_a?(Operation)
      true
    end
  end
end
