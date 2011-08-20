require 'spec_helper'

describe Score, :save do

  it "limits the data to 50 characters" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100, '1'* 55)
    all_scores_have_data('1' * 50)
  end
  
  it "saves no data when none is provide" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100)
    all_scores_have_data(nil)
  end
  
  it "saves the player's username" do
    @player = FactoryGirl.build(:player, {:username => 'dune'})
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100)
    Score.count({:username => 'dune'}).should == 1
  end
  
  it "saves the player's unique value" do
    @player = FactoryGirl.build(:player, {:username => 'blah'})
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100)
    Score.count({:unique => @player.unique}).should == 1
  end
  
  it "saves the player's key" do
    @player = FactoryGirl.build(:player, {:userkey => 'test'})
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100)
    Score.count({:userkey => 'test'}).should == 1
  end
  
  it "saves to the correct leaderboard id" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100)
    Score.count({:leaderboard_id => @leaderboard.id}).should == 1
  end
  
  def all_scores_have_data(data)
    Score.count({'d.d' => data}).should == 1
    Score.count({'w.d' => data}).should == 1
    Score.count({'d.d' => data}).should == 1
  end
end