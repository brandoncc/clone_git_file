# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clone_git_file/version'

Gem::Specification.new do |spec|
  spec.name          = "clone_git_file"
  spec.version       = CloneGitFile::VERSION
  spec.authors       = ["Brandon Conway"]
  spec.email         = ["brandoncc@gmail.com"]

  spec.summary       = "A small tool which allows you to easily clone and open a file from git services"
  spec.homepage      = "https://github.com/brandoncc/clone_git_file"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ["clone_git_file"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-spec-context"
end
