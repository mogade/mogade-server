require 'spec_helper'

describe Score, 'save weekly' do
  it "saves a new weekly score if the player doesn't have a score for this week" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:leaderboard => @leaderboard}))
    Score.save(@leaderboard, @player, 100)
    
    Score.weekly_collection.count.should == 1  
    score_should_exist(100)
  end
  it "saves the new weekly score id to the high scores" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    scores = Factory.build(:high_scores, {:leaderboard => @leaderboard})
    
    @player.stub!(:high_scores).and_return(scores)
    Score.save(@leaderboard, @player, 100)
      
    Score.weekly_collection.find({:_id => scores.weekly_id}).count.should == 1
  end
  it "saves a new weekly score if the player's current weekly is lower than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    create_high_score(88)
    
    Score.save(@leaderboard, @player, 101)
    Score.weekly_collection.count.should == 1      
    score_should_exist(101)
  end
  it "does not save the score if the user's current weekly is higher than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    create_high_score(152)
    
    Score.save(@leaderboard, @player, 151)
    Score.weekly_collection.count.should == 1  
    score_should_exist(152)
  end
  
  
  def score_should_exist(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, :p => points, :dt => @leaderboard.weekly_start}
    Score.weekly_collection.find(selector).count.should == 1
  end
  def create_high_score(points)
    score_id = Score.weekly_collection.insert({:lid => @leaderboard.id,
      :dt => @leaderboard.weekly_start, :p => points, :un => @player.username})

    Factory.create(:high_scores, {:leaderboard_id => @leaderboard.id, :unique => @player.unique,
                :userkey => @player.unique, :weekly_points => points, 
                :weekly_dated => @leaderboard.weekly_start, :weekly_id => score_id})
  end
end