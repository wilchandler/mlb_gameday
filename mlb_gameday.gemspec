# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mlb_gameday/version'

Gem::Specification.new do |spec|
  spec.name          = "mlb_gameday"
  spec.version       = MLBGameday::VERSION
  spec.authors       = ["Steven Hoffman"]
  spec.email         = ["git@fustrate.com"]
  spec.description   = %q{MLB Gameday gem}
  spec.summary       = %q{Fetches gameday data from the MLB Gameday API}
  spec.homepage      = "http://github.com/fustrate/mlb_gameday"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri"
end