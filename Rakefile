require "bundler/gem_tasks"

require "open3"
require "pry"
require "rake/testtask"

# Base path for main file backed repo
require "./lib/rbp/run"

# TODO: wrap in theme options from config and adjust command rather than const

task :run, [:start_folder] do |tsk, args|
  THEME = "flat-orange"
  BASE = File.expand_path(args[:start_folder] || "~/.cache/rbp/")
  Operation::Rbp.register("rbp")
  Operation::Zsh.register("zsh")
  Operation::Urxvt.register("urxvt")

  Rbp::Run.main
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end
