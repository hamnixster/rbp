require "bundler/gem_tasks"
require "standard/rake"

require "open3"
require "pry"
require "rake/testtask"

# Base path for main file backed repo
require "./lib/rbp/run"

# TODO: wrap in theme options from config and adjust command rather than const
THEME = "flat-orange"

task :run, [:start_folder] do |tsk, args|
  BASE = File.expand_path(args[:start_folder] || "~/.cache/rbp/")
  Operation::Rbp.register("rbp")
  Operation::Zsh.register("zsh")
  Operation::Urxvt.register("urxvt")
  Operation::Asdf.register("asdf")
  Operation::Bundle.register("be")

  Rbp::Run.main
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end
