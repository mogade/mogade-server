require 'store.rb'
require 'aws/s3'

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
      Store['leaderboards'].find({:gid => game_id}, {:fields => {:_id => 1}}).each do |data|
        destroy_leaderboard(data['_id'])
      end
      @redis.srem('cleanup:games', game_id)
      count += 1
    end
  end

  def destroy_leaderboards
    count = 0
    while count < 50
      value = @redis.srandmember('cleanup:leaderboards')
      leaderboard_id = BSON::ObjectId.legal?(value) ? BSON::ObjectId.from_string(value) : nil
      destroy_leaderboard(leaderboard_id)

      @redis.srem('cleanup:leaderboards', leaderboard_id)
      count += 1
    end
  end

  def destroy_profile_images(bucket, connect_to_aws = true)
    if connect_to_aws #for testing
      AWS::S3::Base.establish_connection!(:access_key_id => Settings.aws['key'], :secret_access_key => Settings.aws['secret'])
    end
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
  def destroy_leaderboard(leaderboard_id)
    return if leaderboard_id.nil?
    destroy_ranks(leaderboard_id)
    Store['scores'].remove({:lid => leaderboard_id})
    Store['leaderboards'].remove({:_id => leaderboard_id})
  end
  def destroy_ranks(leaderboard_id)
    delete_keys(@redis.keys("lb:?:#{leaderboard_id}:*"))
    delete_keys(@redis.keys("lb:o:#{leaderboard_id}"))
  end

  def destroy_stats(game_id)
    delete_keys(@redis.keys("s:*:#{game_id}:*"))
  end

  def delete_keys(keys)
    @redis.del *keys unless keys.length == 0
  end
end