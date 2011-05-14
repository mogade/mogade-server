class Settings 
  @@settings = YAML::load_file(File.dirname(__FILE__) + '/../config/settings.yml')[Rails.env]
  
  def self.method_missing(key)
    raise MissingConfigOptionError, "#{key.to_s} is not in the config file" unless @@settings.include?(key.to_s)
    @@settings[key.to_s]
  end
  
  def self.hoptoad_key
    @@settings['hoptoad_key']
  end

  class MissingConfigOptionError < StandardError;
  end
end