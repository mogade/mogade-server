class Profile
  include MongoLight::Document
  include ActiveModel::Validations
  mongo_accessor({:name => :n, :enabled => :e, :description => :desc, :images => :i, :leaderboard_id => :lid})
  
  validates_length_of :name, :minimum => 1, :maximum => 25, :allow_blank => false, :message => 'please enter a name'
  validates_length_of :description, :minimum => 0, :maximum => 510, :allow_blank => true, :message => 'please enter a description'
    
  class << self
    def load_for_game(game)
      profile = find_by_id(game.id)
      profile.nil? ? Profile.new({:name => game.name, :_id => game.id, :enabled => false}) : profile
    end
    def create_or_update(name, description, enabled, leaderboard_id, game)
      profile = load_for_game(game)
      profile.name = name
      profile.description = description
      profile.enabled = enabled == 1
      profile.leaderboard_id = Id.from_string(leaderboard_id)
      profile
    end
  end
  
  def save_image(filename, data, index)
    return nil if filename.blank? || index > 6 || data.size > Settings.max_image_length
    return nil unless ['.jpg', '.jpeg', '.png', '.gif'].include?(File.extname(filename).downcase)
    self.images = [] if self.images.nil?
    
    self.images[index] = FileStorage.save_image(filename, data, images[index], index > 0)
    save!
    self.images[index]
  end
  
  def delete_image(index)
    return if self.images.nil? || self.images[index].nil?
    FileStorage.delete_image(self.images[index])
    self.images[index] = nil
    save!
  end
end