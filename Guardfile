guard :rspec, cmd: "rspec" do

  require "guard/rspec/dsl"

  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(%r{^lib/mercadopago/.+\.rb$}) { "spec" }
  watch(%r{^lib/mercadopago/lib/.+\.rb$}) { "spec" }
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/core/.+\.rb$})
  watch(%r{^spec/factories.+_factory\.rb$})
  watch(%r{^spec/features/.+_spec\.rb$})
  watch(%r{^spec/models/.+_spec\.rb$})
  watch(%r{^spec/support/.+\.rb$})

end
