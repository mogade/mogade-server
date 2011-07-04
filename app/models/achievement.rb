class Achievement
  include MongoLight::Document
  include ActiveModel::Validations
  mongo_accessor({:game_id => :gid, :name => :n, :description => :d, :points => :p})
  
  validates_length_of :name, :minimum => 1, :maximum => 50, :allow_blank => false, :message => 'please enter a name'
  validates_length_of :description, :minimum => 1, :maximum => 175, :allow_blank => true, :message => 'please enter a description'
  validates_numericality_of :points, :only_integer => true, :message => 'please enter the amount of points (0-500)'
  validates_inclusion_of :points, :in => 0..500, :message => 'please enter the amount of points (0-500)'
  
  class << self
    def find_for_game(game)
      find({:game_id => game.id}, {:sort => [:name, :ascending]}).to_a
    end
    def create(name, description, points, game)
      Achievement.new({:name => name, :description => description, :points => points, :game_id => game.id})
    end
  end
  
  def update(name, description, points)
    self.name = name
    self.description = description
    self.points = points
    save!
  end
  
  def destroy
    Achievement.remove({:_id => self.id})
    EarnedAchievement.remove({:achievement_id => self.id})
  end
end