class AssetManager
  @@assets = YAML::load_file('config/assets.yml') 
  def self.js(name)
    @@assets['js'][name]
  end
  def self.css(name)
    @@assets['css'][name]
  end
end
