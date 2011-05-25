require 'spec_helper'

describe Score, 'save overall' do
  before(:each) do
    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end
  
  it "saves a new weekly score if the player doesn't have a score for this leaderboard" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:leaderboard => @leaderboard}))
    Score.save(@leaderboard, @player, 22)
    
    Score.overall_collection.count.should == 1
    score_should_exist(22)
  end
  it "saves the new overall score id to the high scores" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    scores = Factory.build(:high_scores, {:leaderboard => @leaderboard})
    
    @player.stub!(:high_scores).and_return(scores)
    Score.save(@leaderboard, @player, 100)
      
    Score.overall_collection.find({:_id => scores.overall_id}).count.should == 1
  end
  it "saves a new overall score if the player's current overall is lower than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    create_high_score(88)
    
    Score.save(@leaderboard, @player, 101)
    Score.overall_collection.count.should == 1
    score_should_exist(101)
  end
  it "does not save the score if the user's current overall is higher than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    create_high_score(152)
    
    Score.save(@leaderboard, @player, 151)
    Score.overall_collection.count.should == 1
    score_should_exist(152)
  end
  
  
  def score_should_exist(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, :p => points, :dt => @now}
    Score.overall_collection.find(selector).count.should == 1
  end
  def create_high_score(points)
    score_id = Score.overall_collection.insert({:lid => @leaderboard.id, :p => points, :un => @player.username, :dt => @now})

    Factory.create(:high_scores, {:leaderboard_id => @leaderboard.id, :unique => @player.unique,
                :userkey => @player.unique, :overall_points => points, :overall_id => score_id})
  end
end