lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mercadopago/version'

Gem::Specification.new do |s|
  s.name          = 'mercadopago'
  s.version       = MercadoPago::VERSION
  s.date          = Time.now
  s.summary       = 'Mercado Pago Gem'
  s.description   = 'This gem allow to use the MercadoPago API in a Ruby Application easily'
  s.authors       = ['Joel Ibaceta', 'Matias Compiano']
  s.email         = 'joel.ibaceta@mercadolibre.com'
  s.homepage      = 'https://github.com/joelibaceta/mp-sdk-ruby'
  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'activesupport'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
  s.license       = 'MIT'
end