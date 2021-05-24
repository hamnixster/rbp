require "bundler/gem_tasks"

require "open3"
require "pry"
require "rake/testtask"

# Base path for main file backed repo
BASE = File.expand_path("~/.cache/rbp/")
require "./lib/rbp/run"

# TODO: wrap in theme options from config and adjust command rather than const
THEME = "flat-orange"

task :run do |tsk, args|
  Operation::Rbp.new("rbp")
  Operation::Zsh.new("zsh")

  Rbp::Run.main
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end
