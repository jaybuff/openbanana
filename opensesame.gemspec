# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opensesame/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["R. Tyler Croy"]
  gem.email         = ["tyler@monkeypox.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "opensesame"
  gem.require_paths = ["lib"]
  gem.version       = Opensesame::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end