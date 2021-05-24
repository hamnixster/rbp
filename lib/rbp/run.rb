require "./lib/rbp/container"

module Rbp
  class Run
    def self.main
      Rbp::Container.register(
        "main-section",
        Bookmark::Section.new(
          "rbp main",
          Rbp::Container["parser.line"],
          Rbp::Container["source.file"].new(Pathname.new("#{BASE}/main")),
          operation: Rbp::Container["operation.rbp"],
          input: "main",
          command: "rbp"
        )
      )

      Rbp::Container["main-section"].source.try_touch
      next_section = Rbp::Container["main-section"]
      loop { next_section, _ = next_section&.execute }
    end
  end
end
