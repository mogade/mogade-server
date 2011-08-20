require 'spec_helper'

describe ScoreDeleter, :delete do
  it "deletes a score if we are removing the overall" do
    leaderboard = FactoryGirl.build(:leaderboard)
    score = FactoryGirl.create(:score, {:username => 'b1', :leaderboard_id => leaderboard.id, :overall => FactoryGirl.build(:score_data, {:points => 23}), :weekly => FactoryGirl.build(:score_data, {:points => 22}), :daily => FactoryGirl.build(:score_data, {:points => 17})})
    
    ScoreDeleter.delete(leaderboard, LeaderboardScope::Overall, [score.id.to_s])
    Score.count.should == 0
  end
  
  it "removes all of the user's ranks when deleting the overall" do
    leaderboard = FactoryGirl.build(:leaderboard)
    score = FactoryGirl.create(:score, {:username => 'b1', :unique => 'un11', :leaderboard_id => leaderboard.id, :overall => FactoryGirl.build(:score_data, {:points => 23})})
    LeaderboardScope::without_yesterday.each{|scope| Rank.save(leaderboard, scope, 'un11', 100)}
    ScoreDeleter.delete(leaderboard, LeaderboardScope::Overall, [score.id.to_s])
    LeaderboardScope::without_yesterday.each{|scope| Store.redis.zcard(Rank.get_key(leaderboard, scope)).should == 0}
  end
  
  it "deletes the weekly and daily scores if we are removing the weekly" do
    leaderboard = FactoryGirl.build(:leaderboard)
    score = FactoryGirl.create(:score, {:username => 'b1', :leaderboard_id => leaderboard.id, :overall => FactoryGirl.build(:score_data, {:points => 23}), :weekly => FactoryGirl.build(:score_data, {:points => 22}), :daily => FactoryGirl.build(:score_data, {:points => 17})})
    
    ScoreDeleter.delete(leaderboard, LeaderboardScope::Weekly, [score.id])
    Score.count({'o.p' => 23, 'w' => nil, 'd' => nil}).should == 1
  end
  
  it "removes the daily and weekly ranks when removing the weekly" do
    leaderboard = FactoryGirl.build(:leaderboard)
    score = FactoryGirl.create(:score, {:username => 'b1', :unique => 'un11', :leaderboard_id => leaderboard.id, :overall => FactoryGirl.build(:score_data, {:points => 23})})
    LeaderboardScope::without_yesterday.each{|scope| Rank.save(leaderboard, scope, 'un11', 100)}
    ScoreDeleter.delete(leaderboard, LeaderboardScope::Weekly, [score.id.to_s])
    Store.redis.zcard(Rank.get_key(leaderboard, LeaderboardScope::Overall)).should == 1
    Store.redis.zcard(Rank.get_key(leaderboard, LeaderboardScope::Weekly)).should == 0
    Store.redis.zcard(Rank.get_key(leaderboard, LeaderboardScope::Daily)).should == 0
  end
  
  it "deletes the daily score if we are removing the daily" do
    leaderboard = FactoryGirl.build(:leaderboard)
    score = FactoryGirl.create(:score, {:username => 'b1', :leaderboard_id => leaderboard.id, :overall => FactoryGirl.build(:score_data, {:points => 23}), :weekly => FactoryGirl.build(:score_data, {:points => 22}), :daily => FactoryGirl.build(:score_data, {:points => 17})})
    
    ScoreDeleter.delete(leaderboard, LeaderboardScope::Daily, [score.id.to_s])
    Score.count({'o.p' => 23, 'w.p' => 22, 'd' => nil}).should == 1
  end
  
  it "removes the daily rank when removing the daily" do
    leaderboard = FactoryGirl.build(:leaderboard)
    score = FactoryGirl.create(:score, {:username => 'b1', :unique => 'un11', :leaderboard_id => leaderboard.id, :overall => FactoryGirl.build(:score_data, {:points => 23})})
    LeaderboardScope::without_yesterday.each{|scope| Rank.save(leaderboard, scope, 'un11', 100)}
    ScoreDeleter.delete(leaderboard, LeaderboardScope::Daily, [score.id.to_s])
    Store.redis.zcard(Rank.get_key(leaderboard, LeaderboardScope::Overall)).should == 1
    Store.redis.zcard(Rank.get_key(leaderboard, LeaderboardScope::Weekly)).should == 1
    Store.redis.zcard(Rank.get_key(leaderboard, LeaderboardScope::Daily)).should == 0
  end
end
