require "open3"
require "pry"

require "./rbp"
require "./rofi"

THEME = "flat-orange"

task :run, [:section, :command] do |tsk, args|
  main(args.fetch(:section, "main")) do |section, lines|
    args[:command] || Rofi.new.call(section, lines)
  end
end
