SimpleCov.start do
  SimpleCov.minimum_coverage 80
  add_group "mercadopago", "lib"
  add_filter "spec"
end
