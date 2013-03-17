source 'http://rubygems.org'

gem 'rails', '3.2.5'
gem 'capistrano', '2.12.0'
gem 'mongo', '1.6.2'
gem 'mongo_ext', :require => 'mongo'
gem 'bson_ext', '1.6.2', :require => 'mongo'
gem 'mongo_light', '0.1.4'
gem 'bcrypt-ruby'
gem 'erubis'
gem 'hiredis', '0.4.5'
gem 'redis', '3.0.3', :require => ['redis/connection/hiredis', 'redis']
gem 'postmark'
gem 'mail'
gem 'aws-s3'
gem 'RubyInline'
gem 'g1nn13-image_science', '1.1', :git => 'git://github.com/karlseguin/image_science.git'
gem 'rspec', '2.10.0'
gem 'oauth'
gem 'rspec-rails', '2.10.1'
gem 'newrelic_rpm'
gem 'error_notifier', '0.0.5'

group :assets do
  gem 'uglifier'
end

group :development do
	gem 'spork', '~> 0.9.2'
	gem 'factory_girl'
end

group :production do
  gem 'execjs'
  gem 'therubyracer'
end