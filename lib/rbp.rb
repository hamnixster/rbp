require "open3"

require "./lib/rofi"

MARKS = {"main" => []}

class Rbp
  def self.main(section)
    command = yield(section, MARKS[section] || [])
  end
end
