class Settings
  @@settings = YAML::load_file(File.dirname(__FILE__) + '/../config/settings.yml')[Rails.env]
  @@aws_root_path = 's3.amazonaws.com/' + @@settings['aws']['bucket'] + '/'
  def self.method_missing(key)
    raise MissingConfigOptionError, "#{key.to_s} is not in the config file" unless @@settings.include?(key.to_s)
    @@settings[key.to_s]
  end

  def self.hoptoad_key
    @@settings['hoptoad_key']
  end

  def self.aws
    @@settings['aws']
  end

  def self.aws_root_path
    @@aws_root_path
  end

  def self.ruby_inline_directory
    @@settings['ruby_inline_directory']
  end

  class MissingConfigOptionError < StandardError;
  end
end