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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.1"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "webmock", "~> 3.1"
  spec.add_development_dependency "pry", "~> 0.10"

  spec.add_dependency "faraday", "~> 0.13.1"
end
