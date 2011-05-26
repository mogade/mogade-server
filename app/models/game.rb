class Game
  include Document
  include ActiveModel::Validations
  mongo_accessor({:name => :name, :secret => :secret, :version => :v})
  
  validates_length_of :name, :minimum => 1, :maximum => 50, :allow_blank => false, :message => 'please enter a name'
  
  class << self
    def create(name)
      Game.new({:name => name, :secret => Id.secret})
    end
    
    def find_by_ids(list)
      return [] if list.blank?
      find({:_id => {'$in' =>  list}}, {:sort => [:name, :ascending]})
    end
  end
  
  def update(name)
    self.name = name
    save!
  end
  
  def destroy
    Store.redis.sadd('cleanup:games', self.id)
    Game.remove({:_id => self.id})
  end
end