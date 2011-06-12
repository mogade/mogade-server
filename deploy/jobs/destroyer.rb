require 'store'

class Destroyer
  
  def initialize
    @redis = Store.redis
  end
  
  def destroy_games
    count = 0
    while count < 50
      value = @redis.srandmember('cleanup:games')
      game_id = BSON::ObjectId.legal?(value) ? BSON::ObjectId.from_string(value) : nil
      return if game_id.nil?
      
      destroy_stats(game_id)
      Leaderboard.find({:game_id => game_id}).each{|l| l.destroy }
      
      @redis.srem('cleanup:games', game_id)
      count += 1
    end
  end
  
  def destroy_leaderboards
    count = 0
    while count < 50
      value = @redis.srandmember('cleanup:leaderboards')
      leaderboard_id = BSON::ObjectId.legal?(value) ? BSON::ObjectId.from_string(value) : nil
      return if leaderboard_id.nil?
      
      destroy_ranks(leaderboard_id)
      Score.remove({:lid => leaderboard_id})
            
      @redis.srem('cleanup:leaderboards', leaderboard_id)
      count += 1
    end
  end
  
  def destroy_profile_images(bucket)
    @redis.keys('cleanup:images:*').each do |key|
      timestamp = Date.strptime(key.split(':')[2], '%y%m%d').to_time
      next unless Time.now.utc - timestamp > 86400
      @redis.smembers(key).each do |member|
        AWS::S3::S3Object.delete(member, bucket)
        AWS::S3::S3Object.delete('thumb' + member, bucket)
      end
      @redis.del(key)
    end
  end
  
  private
  def destroy_ranks(leaderboard_id)
    delete_keys(@redis.keys("lb:?:#{leaderboard_id}:*"))
    delete_keys(@redis.keys("lb:o:#{leaderboard_id}"))
  end
  
  def destroy_stats(game_id)
    delete_keys(@redis.keys("s:*:#{game_id}:*"))
  end
  
  def delete_keys(keys)
    @redis.del *keys unless keys.blank?
  end
end