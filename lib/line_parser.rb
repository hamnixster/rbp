class LineParser < ApplicationParser
  def call(line)
    command, input = line.split(" ")
    Bookmark::Base.new(id: input, command: command)
  end
end
