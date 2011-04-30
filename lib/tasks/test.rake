namespace :test do
  desc 'Running specification tests' 
  RSpec::Core::RakeTask.new(:specs) do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.rcov = false
  end
  
  task :all => [:specs] 
end