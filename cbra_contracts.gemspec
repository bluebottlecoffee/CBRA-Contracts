# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cbra_contracts/version'

Gem::Specification.new do |spec|
  spec.name          = 'CBRA-Contracts'
  spec.version       = CBRAContracts::VERSION
  spec.authors       = ['Blue Bottle Coffee']
  spec.email         = ['opensource@bluebottlecoffee.com']

  spec.summary       = 'DSL to delcare your Rails component contracts'
  spec.description   = 'DSL to delcare your Rails component contracts'
  spec.license       = 'AGPL'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
