# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib/",__FILE__)

require "guard/cunit/version"

Gem::Specification.new do |s|
  s.name        = "guard-cunit"
  s.version     = Guard::CunitGuard::VERSION
  s.authors	= ["Tea Cup On Rocking Chair"]
  s.email       = ["strandjata@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Guard gem for CUnit-driven projects}
  s.description = %q{Guard Cunit should automatically build your C project and run CUnit based tests}

  s.rubyforge_project = "guard-cunit"
  
  # specify any dependencies here; for example:
  s.add_dependency 'guard', '>= 1.1'		
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'  

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
end
