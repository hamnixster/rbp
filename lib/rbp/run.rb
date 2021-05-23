require "./lib/rbp/container"

module Rbp
  class Run
    def self.main(command: nil)
      section ||=
        Rbp::Container["repository.section.folder.base"]
          .find_or_create(command).tap { |bm| bm.operation = Rbp::Container["operation.rbp"] }

      section&.execute
    end
  end
end
