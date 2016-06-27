SimpleCov.start do
  SimpleCov.minimum_coverage 90
  add_group "mercadopago", "lib"
  add_filter "spec"
end
