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
  spec.description   = 'A simple wrapper for the Timekit.io rest API'
  spec.homepage      = "https://github.com/cromulus/timekitapi"
  spec.license       = 'MIT'

  spec.cert_chain  = ['certs/cromulus.pem']
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.org"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9', '>= 1.9.0'
  spec.add_development_dependency 'rake','~> 10.4', '>= 10.4.0'
  spec.add_development_dependency 'rspec','~> 3.4', '>= 3.4.0'
  spec.add_development_dependency 'vcr','~> 3.0', '>= 3.0.0'
  spec.add_development_dependency 'webmock', '~> 1.22', '>= 1.22.0'

  spec.add_runtime_dependency 'faraday', '~> 0.9', '>= 0.9.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.10','>= 0.10.0'
  spec.add_runtime_dependency 'net', '~> 0.3', '>= 0.3.0'
  spec.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.0'
  spec.add_runtime_dependency 'net-http-persistent', '~> 2.9', '>= 2.9.0'
end
