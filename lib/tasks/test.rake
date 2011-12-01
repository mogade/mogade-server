require 'rspec'
require 'rspec/core/rake_task'

desc 'Running specification tests'
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rcov = false
end


