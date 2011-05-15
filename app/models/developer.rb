require 'bcrypt'
class Developer
  include Document
  mongo_accessor({:name => :n, :email => :e, :password => :pw, :action => :a, :status => :s, :game_ids => :gids})
  
  class << self
    def find_by_credential(email, password)
      return nil if email.blank? || password.blank?
      developer = find_by_email(email)
      return developer.nil? || BCrypt::Password.new(developer.password) != password ? nil : developer
    end
    
    def find_by_email(email)
      return nil if email.blank?
      find_one({:email => email})
    end
    
    def find_by_action(action)
      find_one({:action => action})
    end
    
    def set_new_action(email)
      developer = Developer.find_by_email(email)
      return nil if developer.nil?
      developer.action = Id.new
      developer.save!
      return developer
    end
  end
  
  def owns?(game)
    !self.game_ids.nil? && self.game_ids.include?(game.id)
  end
  def created_game!(game)
    self.game_ids = [] if self.game_ids.nil?
    self.game_ids << game.id 
    save!
  end
  
  def reset_password(password)
    self.password = BCrypt::Password.create(password)
    activate!
    return true
  end
  
  def activate!
    self.status = DeveloperStatus::Enabled
    self.action = nil    
    save!
    self
  end
end