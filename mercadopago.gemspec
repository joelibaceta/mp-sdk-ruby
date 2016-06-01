lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mercadopago/version'

Gem::Specification.new do |s|
  s.name        = 'mercadopago'
  s.version     = '2.0.1'
  s.date        = '2016-05-26'
  s.summary     = 'Mercado Pago (Flavor1 / Flavor3) Gem'
  s.description = 'Mercado Pago (Flavor1 / Flavor3) Gem'
  s.authors     = ['Joel Ibaceta', 'Matias Compiano']
  s.email       = 'mail@joelibaceta.com'
  s.home_page   = 'https://github.com/joelibaceta/mp-sdk-ruby'
  s.files       = `git ls-files`.split($/)
  s.test_files  = spec.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.license     = 'MIT'
end