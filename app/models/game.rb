class Game
  include MongoLight::Document
  include ActiveModel::Validations
  mongo_accessor({:name => :name, :secret => :secret, :version => :v, :stats => :s})

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

  def set_stat_names(names)
    return if names.blank?
    self.stats = (names.map{|name| name.blank? ? nil : name[0..19]})[0..Stat::CUSTOM_COUNT-1]
    save!
  end

  def stat_name(index)
    stats && stats[index]
  end

  def destroy
    Store.redis.sadd('cleanup:games', self.id)
    Game.remove({:_id => self.id})
  end
end