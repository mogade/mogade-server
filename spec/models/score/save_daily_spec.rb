require 'spec_helper'

describe Score, 'save daily' do
  it "saves a new daily score if the player doesn't have a score for today" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores))
    Score.save(@leaderboard, @player, 100)
    daily_should_exist(100)
  end
  it "saves a new daily score if the player's current daily is lower than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:daily_points => 99}))
    create_daily(99)
    
    Score.save(@leaderboard, @player, 100)
    daily_should_exist(100)
  end
  it "does not save the score if the user's current daily is higher than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:daily_points => 150}))
    create_daily(150)
    
    Score.save(@leaderboard, @player, 149)
    daily_should_exist(150)
  end
  
  
  def daily_should_exist(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, 
                :u => @player.unique, :p => points, 
                :dt => @leaderboard.daily_start}
    Score.daily_collection.find(selector).count.should == 1
  end
  def create_daily(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, 
                :u => @player.unique, :p => points, 
                :dt => @leaderboard.daily_start}
    Score.daily_collection.save(selector)
  end
end