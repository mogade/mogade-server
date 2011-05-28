class HighScore
  include EmbeddedDocument
  mongo_accessor({:points => :p, :stamp => :s, :id => :id, :data => :d})
  
  class << self
    def blank
      HighScore.new({:points => 0})
    end
  end
end