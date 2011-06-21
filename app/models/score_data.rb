class ScoreData
  include EmbeddedDocument
  attr_accessor :is_default
  mongo_accessor({:points => :p, :stamp => :s, :data => :d, :dated => :dt})

  class << self
    def blank
      ScoreData.new({:points => 0, :is_default => true})
    end
  end

end