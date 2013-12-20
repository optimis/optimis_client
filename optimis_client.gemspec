# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "optimis_client/version"

Gem::Specification.new do |s|
  s.name        = "optimis_client"
  s.version     = OptimisClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["OptimisDev Taipei Team"]
  s.email       = ["devteam-tw@optimiscorp.com"]
  s.homepage    = "http://optimisdev.com"
  s.summary     = %q{Optimis Client library}
  s.description = %q{a Ruby client library for Optimis Service}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "typhoeus", "~> 0.6.5"
  s.add_dependency "yajl-ruby"

  s.add_development_dependency "rspec", "~> 2.5"
  s.add_development_dependency "rack", "~> 1.5"
end
