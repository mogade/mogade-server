require File.expand_path('../config/application', __FILE__)
require 'rake'

module ::Mogade
  class Application
    include Rake::DSL if defined?(Rake::DSL)
  end
end

module ::RakeFileUtils
  extend Rake::FileUtilsExt if defined?(Rake::FileUtilsExt)
end

Mogade::Application.load_tasks