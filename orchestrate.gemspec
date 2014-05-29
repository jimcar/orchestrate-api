lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'orchestrate/version'

Gem::Specification.new do |s|
	s.name          = 'orchestrate'
	s.version       = Orchestrate::VERSION
	s.authors       = ['Matthew Lyon', 'Justin Mecham', 'James Carrasquer']
	s.email         = ['matthew@lyonheart.us', 'justin@mecham.me', 'jimcar@aracnet.com']
	s.summary       = 'Ruby client for Orchestrate.io'
	s.description   = 'Client for the Orchestrate REST API'
	s.homepage      = 'https://github.com/orchestrate-io/orchestrate-ruby'
	s.license       = 'MIT'

	s.files         = `git ls-files -z`.split("\x0")
	s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
	s.test_files    = s.files.grep(%r{^(test|spec|features)/})
	s.require_paths = ["lib"]

  s.add_dependency "faraday", "~> 0.9"
  s.add_dependency "faraday_middleware", "~> 0.9", ">= 0.9.1"
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "typhoeus"
  s.add_development_dependency "em-http-request"
  s.add_development_dependency "em-synchrony"
end
