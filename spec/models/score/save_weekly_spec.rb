require 'spec_helper'

describe Score, 'save weekly' do
  it "saves a new weekly score if the player doesn't have a score for this week" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:leaderboard => @leaderboard}))
    Score.save(@leaderboard, @player, 100)
    weekly_should_exist(100)
  end
  it "saves a new weekly score if the player's current weekly is lower than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:weekly_points => 88, :leaderboard => @leaderboard}))
    create_weekly(88)
    
    Score.save(@leaderboard, @player, 101)
    weekly_should_exist(101)
  end
  it "does not save the score if the user's current weekly is higher than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:weekly_points => 152, :leaderboard => @leaderboard}))
    create_weekly(152)
    
    Score.save(@leaderboard, @player, 151)
    weekly_should_exist(152)
  end
  
  
  def weekly_should_exist(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, 
                :u => @player.unique, :p => points, 
                :dt => @leaderboard.weekly_start}
    Score.weekly_collection.find(selector).count.should == 1
  end
  def create_weekly(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, 
                :u => @player.unique, :p => points, 
                :dt => @leaderboard.weekly_start}
    Score.weekly_collection.save(selector)
  end
end