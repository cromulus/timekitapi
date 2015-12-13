# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timekitapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'timekitapi'
  spec.version       = TimekitApi::VERSION
  spec.authors       = ['Erik Sälgström Peterson','Bill Cromie']
  spec.email         = ['erik@swedenunlimited.com','bill@cromie.org']

  spec.summary       = 'A simple wrapper for the TimeKit.io rest API'
  spec.homepage      = "https://github.com/cromulus/timekitapi"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'net'
  spec.add_dependency 'json'
  spec.add_dependency 'net-http-persistent'
end
