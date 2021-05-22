require "pry"
require "rake/testtask"

require "./lib/rbp"

THEME = "flat-orange"

task :run, [:section, :command] do |tsk, args|
  Rbp.main(args.fetch(:section, "main")) do |section, lines|
    args[:command] || Rofi.new.call(section, THEME, lines)
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end
