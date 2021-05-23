require "./lib/rbp/container"

module Rbp
  class Run
    def self.main
      Rbp::Container["main-section"].execute
    end
  end
end
