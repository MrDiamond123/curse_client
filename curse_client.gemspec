# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'curse_client/version'

Gem::Specification.new do |spec|
  spec.name          = "curse_client"
  spec.version       = CurseClient::VERSION
  spec.authors       = ["Andy Miller"]
  spec.email         = ["amcoder@gmail.com"]

  spec.homepage      = "https://github.com/amcoder/curse_client"
  spec.summary       = %q{A Minecraft curse client for the command line}
  spec.description   = %q{This is an unofficial client for curse-hosted Minecraft modpacks.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "bzip2-ffi", "~> 1.0"
  spec.add_runtime_dependency "rubyzip", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
