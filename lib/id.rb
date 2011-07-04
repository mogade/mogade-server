module Id
  def self.new
    MongoLight::Id.new
  end
  def self.valid?(id)
    MongoLight::Id.valid?(id)
  end
  def self.from_string(id)
    MongoLight::Id.from_string(id)
  end
  def self.expired?(id, days)
    ((Time.now - id.generation_time) / 86400).floor > days
  end
  def self.secret
    (0..(rand(15)+20)).map{48.+(rand(74)).chr}.join.gsub('\\', '[]')
  end
end