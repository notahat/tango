# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tango/version"

Gem::Specification.new do |s|
  s.name        = "tango"
  s.version     = Tango::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pete Yandell"]
  s.email       = ["pete@notahat.com"]
  s.homepage    = ""
  s.summary     = %q{Experiment in deployment tools.}
  s.description = %q{Experiment in deployment tools, taking ideas from babushka and elsewhere.}

  s.add_development_dependency "rspec"

  s.rubyforge_project = "tango"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
