require File.expand_path('../config/application', __FILE__)
include Rake::DSL if defined?(Rake::DSL)
require 'rake'

module ::Mogade
  class Application
    include Rake::DSL
  end
end

module ::RakeFileUtils
  extend Rake::FileUtilsExt
end

Mogade::Application.load_tasks