# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grade/version'

Gem::Specification.new do |spec|
  spec.name          = "grade"
  spec.version       = Grade::VERSION
  spec.authors       = ["kristenmills"]
  spec.email         = ["kristen@kristen-mills.com"]
  spec.summary       = "Tool for helping with 250"
  spec.description   = "Tool for helping with 250"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "git"
  spec.add_runtime_dependency "colorize"
end
