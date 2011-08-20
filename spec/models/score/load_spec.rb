require 'spec_helper'

describe Score, :load do
  it "return's the player's high scores for the given leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score, {:leaderboard_id => leaderboard.id, :unique => player.unique, :daily => FactoryGirl.build(:score_data, {:points => 122, :stamp => Time.now}), :weekly => FactoryGirl.build(:score_data, {:points => 234, :stamp => Time.now}), :overall => FactoryGirl.build(:score_data, {:points => 400})})
    
    score = Score.load(leaderboard, player)
    score.leaderboard_id.should == leaderboard.id
    score.unique.should == player.unique
    score.daily.points.should == 122
  end
  it "return's an empty new scores object if the player doesn't have any scores for the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    
    score = Score.load(leaderboard, player)
    score.leaderboard_id.should == leaderboard.id
    score.unique.should == player.unique
    score.userkey.should == player.userkey
    score.daily.points.should == 0
    score.weekly.points.should == 0
  end
  it "returns 0 for the daily score if it is no longer the correct day" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score, {:leaderboard_id => leaderboard.id, :unique => player.unique, :daily => FactoryGirl.build(:score_data, {:points => 122, :stamp => Time.now - 1000000})})
    
    score = Score.load(leaderboard, player)
    score.leaderboard_id.should == leaderboard.id
    score.unique.should == player.unique
    score.daily.points.should == 0
  end
  it "returns 0 for the weekly score if it is no longer the correct week" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score, {:leaderboard_id => leaderboard.id, :unique => player.unique, :weekly => FactoryGirl.build(:score_data, {:points => 422, :stamp => Time.now - 1000000})})
    
    score = Score.load(leaderboard, player)
    score.leaderboard_id.should == leaderboard.id
    score.unique.should == player.unique
    score.weekly.points.should == 0
  end
  
end