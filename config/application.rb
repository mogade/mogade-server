require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
#require "rails/test_unit/railtie"
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Mogade
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end
