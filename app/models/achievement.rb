class Achievement
  include Document
  include ActiveModel::Validations
  mongo_accessor({:game_id => :gid, :name => :n, :description => :d, :points => :p})
  
  validates_length_of :name, :minimum => 1, :maximum => 50, :allow_blank => false, :message => 'please enter a name'
  validates_length_of :description, :minimum => 1, :maximum => 175, :allow_blank => true, :message => 'please enter a description'
  validates_format_of :points, :with => /\d{1,3}/,  :message => 'please enter the amount of points (0-999)'  
  
  class << self
    def find_for_game(game)
      find({:game_id => game.id}, {:sort => [:name, :ascending]}).to_a
    end
    def create(name, description, points, game)
      Achievement.new({:name => name, :description => description, :points => points, :game_id => game.id})
    end
  end
  
end