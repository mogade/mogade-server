require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)
if defined?(Bundler)
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module Mogade
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.precompile += %w(*.js  *.css)
  end
end
