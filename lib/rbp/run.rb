require "./lib/rbp/container"

module Rbp
  class Run
    def self.main(command: nil, section: nil)
      section ||=
        Rbp::Container["repository.section.folder"]
          .find_or_create(command).tap { |bm| bm.set_operation("rbp") }

      command = section&.execute
      command&.execute if command.is_a?(Operation)
      true
    end
  end
end
