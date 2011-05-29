class ScoreData
  include EmbeddedDocument
  mongo_accessor({:points => :p, :stamp => :s, :data => :d, :dated => :dt})

  class << self
    def blank
      ScoreData.new({:points => 0})
    end
  end

end