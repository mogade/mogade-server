require 'spec_helper'

describe ScoreDeleter, :wipe do
  it "deletes all scores" do
    game1 = FactoryGirl.create(:game, {:id => Id.new})
    game2 = FactoryGirl.create(:game, {:id => Id.new})
    leaderboard1 = FactoryGirl.create(:leaderboard, {:game_id => game1.id, :id => Id.new})
    leaderboard2 = FactoryGirl.create(:leaderboard, {:game_id => game1.id, :id => Id.new})
    leaderboard3 = FactoryGirl.create(:leaderboard, {:game_id => game2.id, :id => Id.new})
    
    FactoryGirl.create(:score, {:username => '1', :leaderboard_id => leaderboard1.id})
    FactoryGirl.create(:score, {:username => '2', :leaderboard_id => leaderboard1.id})
    FactoryGirl.create(:score, {:username => '3', :leaderboard_id => leaderboard2.id})
    FactoryGirl.create(:score, {:username => '4', :leaderboard_id => leaderboard2.id})
    FactoryGirl.create(:score, {:username => '5', :leaderboard_id => leaderboard3.id})
    FactoryGirl.create(:score, {:username => '6', :leaderboard_id => leaderboard3.id})
    
    ScoreDeleter.wipe(game1)
    Score.count.should == 2
    Score.count({:lid => leaderboard3.id}).should == 2
  end
  
  it "delets all ranks" do
    game1 = FactoryGirl.create(:game, {:id => Id.new})
    game2 = FactoryGirl.create(:game, {:id => Id.new})
    leaderboard1 = FactoryGirl.create(:leaderboard, {:game_id => game1.id, :id => Id.new})
    leaderboard2 = FactoryGirl.create(:leaderboard, {:game_id => game1.id, :id => Id.new})
    leaderboard3 = FactoryGirl.create(:leaderboard, {:game_id => game2.id, :id => Id.new})
    
    LeaderboardScope::all_scopes.each{|scope| Rank.save(leaderboard1, scope, 'un11', 100)}
    LeaderboardScope::all_scopes.each{|scope| Rank.save(leaderboard2, scope, 'un11', 100)}
    LeaderboardScope::all_scopes.each{|scope| Rank.save(leaderboard3, scope, 'un11', 100)}
    
    ScoreDeleter.wipe(game1)
    Store.redis.keys("lb:*:#{leaderboard1.id}*").length.should == 0
    Store.redis.keys("lb:*:#{leaderboard2.id}*").length.should == 0
    Store.redis.keys("lb:*:#{leaderboard3.id}*").length.should == 4 
  end
end
