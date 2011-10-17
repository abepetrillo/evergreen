# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'evergreen/version'

Gem::Specification.new do |s|
  s.name = "evergreen"
  s.rubyforge_project = "evergreen"
  s.version = Evergreen::VERSION

  s.authors = ["Jonas Nicklas"]
  s.email = ["jonas.nicklas@gmail.com"]
  s.description = "Run Jasmine JavaScript unit tests, integrate them into Ruby applications."

  s.files = Dir.glob("{bin,lib,spec,config}/**/*") + %w(README.rdoc)
  s.extra_rdoc_files = ["README.rdoc"]
  s.executables = ['evergreen']

  s.homepage = "http://github.com/jnicklas/evergreen"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.6"
  s.summary = "Run Jasmine JavaScript unit tests, integrate them into Ruby applications."

  s.add_runtime_dependency("capybara", ["~> 1.0"])
  s.add_runtime_dependency("launchy")
  s.add_runtime_dependency("sinatra", ["~> 1.1"])
  s.add_runtime_dependency("json_pure")
  s.add_runtime_dependency("coffee-script")

  s.add_development_dependency('rspec', ['~> 2.0'])
  s.add_development_dependency('capybara-webkit', ['>= 1.0.0.beta4'])
  s.add_development_dependency('therubyracer', ['~> 0.9'])
  s.add_development_dependency('rails', ['~> 3.1.1'])
end
