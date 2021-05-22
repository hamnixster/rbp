require "bundler/gem_tasks"

require "open3"
require "pry"
require "rake/testtask"

require "./lib/rbp/run"

THEME = "flat-orange"

task :run, [:command] do |tsk, args|
  Rbp::Run.main(command: args.fetch(:command, "rbp main"))
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end
