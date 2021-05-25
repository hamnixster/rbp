require "./lib/rbp/container"

module Rbp
  class Run
    def self.main
      Rbp::Container.register(
        "main-section",
        Bookmark::Section.new(
          "rbp main",
          Rbp::Container["parser.line"],
          Rbp::Container["source.file"].new(Pathname.new("#{BASE}/main.rbp")),
          nil,
          operation: Rbp::Container["operation.rbp"],
          command: "rbp"
        )
      )

      Rbp::Container["main-section"].source.try_touch
      next_section = Rbp::Container["main-section"]
      loop do
        next_section, _ = next_section&.execute
        break unless next_section
      end
    end
  end
end
