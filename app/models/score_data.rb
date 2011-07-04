class ScoreData
  include MongoLight::EmbeddedDocument
  mongo_accessor({:points => :p, :stamp => :s, :data => :d, :dated => :dt})

  class << self
    def blank
      score = ScoreData.new({:points => 0})
    end
  end

end