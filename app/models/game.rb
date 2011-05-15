class Game
  include Document
  include ActiveModel::Validations
  mongo_accessor({:name => :name, :secret => :secret})
  
  validates_length_of :name, :minimum => 1, :maximum => 50, :allow_blank => false, :message => 'please enter a name'
  
  class << self
    def create(name)
      Game.new({:name => name, :secret => Id.secret})
    end
  end
end