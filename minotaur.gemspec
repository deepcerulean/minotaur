# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minotaur/version'

Gem::Specification.new do |gem|
  gem.name          = "minotaur"
  gem.version       = Minotaur::VERSION
  gem.authors       = ["jweissman"]
  gem.email         = ["joseph.weissman@tapjoy.com"]
  gem.description   = %q{a collection of tools for generating labyrinths}
  gem.summary       = %q{dungeons in ruby!}
  #gem.homepage      = "http://labyrinth.ontology.io"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('dice')
  #gem.add_dependency('thor')
  #gem.add_dependency('highline')
end
