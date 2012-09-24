# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yipit/version"

Gem::Specification.new do |s|
  s.name        = "yipit_n4l"
  s.version     = Yipit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Deeden", "Mark Coates"]
  s.email       = ["mark@nest4less.com"]
  s.homepage    = "http://github.com/Nest4LessDev/yipit"
  s.summary     = %q{A simple wrapper for the Yipit API}
  s.description = %q{A simple wrapper for the Yipit API}

  s.rubyforge_project = "yipit_n4l"
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('vcr')
  s.add_development_dependency('fakeweb')
  s.add_development_dependency('yard')
  s.add_development_dependency('maruku')
  s.add_runtime_dependency("faraday")
  s.add_runtime_dependency("faraday_middleware")
  s.add_runtime_dependency("typhoeus")
  s.add_runtime_dependency('hashie')
  s.add_runtime_dependency('multi_json')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
