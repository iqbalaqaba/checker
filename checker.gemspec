# -*- encoding : utf-8 -*-
require File.expand_path('../lib/checker/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'checker'
  s.version     = Checker::VERSION
  s.date        = '2015-03-02'
  s.summary     = "Syntax checker for various files"
  s.description = "A collection of modules which every is designed to check syntax for specific files."
  s.authors     = ["Jacek Jakubik", "Tomasz Pewiński"]
  s.email       = ['jacek.jakubik@netguru.pl', 'tomasz.pewinski@netguru.pl']
  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage    = 'http://github.com/netguru/checker'
  s.add_dependency 'colorize', '~> 0.7.0'
  s.add_dependency 'rubocop', '~> 0.28.0'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end
