class ScoreData
  include EmbeddedDocument
  attr_accessor :is_default
  mongo_accessor({:points => :p, :stamp => :s, :data => :d, :dated => :dt})

  class << self
    def blank
      score = ScoreData.new({:points => 0})
      score.is_default = true
      score
    end
  end

end