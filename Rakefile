require 'rake/testtask'

require 'cucumber/rake/task'

task :default => [:spec]

Rake::TestTask.new do |t|
  t.pattern = './spec/**/*_test.rb'
end

desc "update bundled certs"
task :update_certs do
  require "restclient"
  File.open(File.join(File.dirname(__FILE__), 'lib', 'data', 'ca-certificates.crt'), 'w') do |file|
    resp = RestClient.get "https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt"
    abort("bad response when fetching bundle") unless resp.code == 200
    file.write(resp.to_str)
  end
end



Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty"
end