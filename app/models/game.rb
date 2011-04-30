class Game
  include Document
  mongo_accessor({:secret => :secret})
end