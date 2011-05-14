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
      find_one(:email => email)
    end
  end
  
  def activate!
    self.status = DeveloperStatus::Enabled
    self.action = nil    
    save!
    self
  end
end