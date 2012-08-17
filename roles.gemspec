# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "roles/version"

Gem::Specification.new do |s|
  s.name        = "roles"
  s.version     = Roles::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["liufengyun"]
  s.email       = ["liufengyunchina@gmail.com"]
  s.homepage    = "http://github.com/liufengyun/roles"
  s.summary     = %q{Roles library with resource scoping}
  s.description = %q{An extremely simple roles library inspired by rolify}

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  if defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"
    s.add_development_dependency "activerecord-jdbcsqlite3-adapter"
  else
    s.add_development_dependency "sqlite3"
  end
  s.add_development_dependency "activerecord", ">= 3.1.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">= 2.0"
  s.add_development_dependency "rspec-rails", ">= 2.0"
  s.add_development_dependency "bundler" 
end
