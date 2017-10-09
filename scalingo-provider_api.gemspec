# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scalingo/provider_api/version"

Gem::Specification.new do |spec|
  spec.name          = "scalingo-provider_api"
  spec.version       = Scalingo::ProviderApi::VERSION
  spec.authors       = ["Jonathan Hurter"]
  spec.email         = ["john@scalingo.com"]

  spec.summary       = %q{Communication between a provider and Scalingo}
  spec.description   = %q{A gem that implement the basic method to communicate between an addon provider and the Scalingo API}
  spec.homepage      = "https://github.com/Scalingo/scalingo-provider-api-gem"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.1.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday", "~> 0.13.1"
end
