source 'http://rubygems.org'
  
gem 'rails', '3.1.1'
gem 'capistrano', '2.9.0'
gem 'mongo', '1.4.0'
gem 'mongo_ext', :require => 'mongo'
gem 'bson_ext', '1.4.0', :require => 'mongo'
gem 'mongo_light'
gem 'bcrypt-ruby'
gem 'erubis'
gem 'hiredis', '~> 0.3.1'
gem 'redis', '~> 2.2.0', :require => ['redis/connection/hiredis', 'redis']
gem 'hoptoad_notifier'
gem 'postmark'
gem 'mail'
gem 'aws-s3'
gem 'RubyInline'
gem 'g1nn13-image_science', '1.0', :git => 'git://github.com/karlseguin/image_science.git'
gem 'rspec'
gem 'rspec-rails'
gem 'newrelic_rpm'

group :assets do
  gem 'uglifier'
end

group :development do  
	gem 'spork', '~> 0.9.0.rc9'
	gem 'factory_girl'
end

group :production do
  gem 'execjs'
  gem 'therubyracer'
end