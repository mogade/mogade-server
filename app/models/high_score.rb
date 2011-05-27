class HighScore
  include EmbeddedDocument
  mongo_accessor({:points => :p, :stamp => :s, :id => :id})
  
  class << self
    def blank
      HighScore.new({:points => 0})
    end
  end
end