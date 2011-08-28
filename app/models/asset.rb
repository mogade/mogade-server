class Asset
  include MongoLight::Document
  include ActiveModel::Validations
  mongo_accessor({:game_id => :gid, :type => :t, :name => :n, :meta => :m, :file => :f, :dated => :d})
  
  validates_length_of :name, :minimum => 1, :maximum => 50, :allow_blank => false, :message => 'please enter a name'
  validates_length_of :meta, :minimum => 1, :maximum => 1000, :allow_blank => true, :message => 'meta information should be blank or less than 1000 characters'
  validates_numericality_of :type, :allow_blank => false, :only_integer => true, :message => 'please enter a type between 0 and 100'
  
  class << self
    def find_for_game(game, attributes_only = false)
      options = {:sort => [:name, :ascending], :raw => attributes_only}
      options[:fields] = {:_id => false} if attributes_only #ugly
      find({:game_id => game.id}, options).to_a
    end
    def create(name, type, meta, game)
      Asset.new({:name => name, :type => type, :meta => meta, :game_id => game.id, :dated => Time.now.utc})
    end
  end
  
  def update(name, type, meta)
    self.name = name
    self.type = type
    self.meta = meta
    save!
  end
  
  def destroy
    FileStorage.delete_asset(file) if file
    Asset.remove({:_id => id})
  end
end