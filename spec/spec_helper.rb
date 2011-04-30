require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  RSpec.configure do |config|
    config.mock_with :rspec
  end
end

Spork.each_run do
end
RSpec.configure do |config|
  config.before(:each) do
    Store.database.collections.each do |collection|
      unless collection.name.match(/^system\./)
        collection.remove
      end
    end
  end
end