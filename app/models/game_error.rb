class GameError
  include Document
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
    
    def count_for_game(game)
      return 0 if game.blank?
      return count(:conditions => {:gid => game.id})
    end
    
    def paged_for_game(game, params)
      return [] if game.blank?
      page = params[:page].to_i || 1
      offset = ((page-1) * 10).floor
      offset = 0 if offset < 0      
      all(:conditions => {:gid => game.id}, :sort => 'uat desc', :limit => 10, :offset => offset, :fields => [:subject, :details, :count, :uat, :cat])
    end
  end
end


