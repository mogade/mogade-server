class GameError
  include MongoLight::Document
  mongo_accessor({:game_id => :gid, :subject => :s, :details => :d, :hash => :h, :count => :c, :dated => :dt, :updated => :ut})  

  class << self
    def create(game, subject, details)
      subject = subject[0..149]
      details = details.blank? ? '' : details[0..1999]
      hash = get_hash(game.id, subject, details)
      date = Time.now.utc
      if count({:hash => hash}) == 1
        update({:hash => hash}, {'$inc' => {:count => 1}, '$set' => {:updated => date}})
      else
        error = GameError.new({:game_id => game.id, :subject => subject, :details => details, :hash => hash, :count => 1, :dated => date, :updated => date})
        error.save!
      end
    end
    
    def get_hash(game_id, subject, details)
      return Digest::SHA1.hexdigest(game_id.to_s + subject + details)
    end
  
    def paged(game, page)
      page = 1 if page < 1 
      offset = ((page-1) * 10).floor
      find({:game_id => game.id}, {:sort => [:uat, :descending], :limit => 10, :skip => offset})
    end
  end
end


