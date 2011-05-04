require 'spec_helper'

describe Score, 'save overall' do
  it "saves a new weekly score if the player doesn't have a score for this leaderboard" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores))
    Score.save(@leaderboard, @player, 22)
    overall_should_exist(22)
  end
  it "saves a new overall score if the player's current overall is lower than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:overall_points => 88}))
    create_overall(88)
    
    Score.save(@leaderboard, @player, 101)
    overall_should_exist(101)
  end
  it "does not save the score if the user's current overall is higher than the new one" do
    @player = Factory.build(:player)
    @leaderboard = Factory.build(:leaderboard)
    @player.stub!(:high_scores).and_return(Factory.build(:high_scores, {:overall_points => 152}))
    create_overall(152)
    
    Score.save(@leaderboard, @player, 151)
    overall_should_exist(152)
  end
  
  
  def overall_should_exist(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, 
                :u => @player.unique, :p => points, 
                :dt => {'$exists' => false}}
    Score.overall_collection.find(selector).count.should == 1
  end
  def create_overall(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, 
                :u => @player.unique, :p => points}
    Score.overall_collection.save(selector)
  end
end