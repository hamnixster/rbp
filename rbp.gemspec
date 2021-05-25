lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbp/version"

Gem::Specification.new do |spec|
  spec.name = "rbp"
  spec.authors = ["Graham Bouvier"]
  spec.email = ["hamnixster@gmail.com"]
  spec.license = "MIT"
  spec.version = Rbp::VERSION.dup

  spec.summary = "A rofi based launcher with bookmark and editing support"
  spec.description = spec.summary
  spec.homepage = ""
  spec.files = Dir["LICENSE", "README.org", "rbp.gemspec", "lib/**/*"]
  spec.bindir = "bin"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_runtime_dependency "dry-system", "~> 0.15"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
