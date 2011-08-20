require 'spec_helper'

describe ScoreDaily, 'save' do
  before(:each) do
    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end

  it "saves a new score" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    ScoreDaily.save(leaderboard, player, 100, 'd1')
    
    ScoreDaily.count.should == 1
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :unique => player.unique, :username => player.username, :points => 100, :data => 'd1', :stamp => leaderboard.daily_stamp, :dated => @now}).should == 1
  end
  
  it "saves a score with no data" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    ScoreDaily.save(leaderboard, player, 100)
    
    ScoreDaily.count.should == 1
    ScoreDaily.count({:data => nil}).should == 1
  end
  
  it "limits the data to 50 characters" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    ScoreDaily.save(leaderboard, player, 100, 'z' * 55)
    
    ScoreDaily.count.should == 1
    ScoreDaily.count({:data => 'z' * 50}).should == 1
  end
  
  it "updates the score at the giving stamp" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score_daily, {:leaderboard_id => leaderboard.id, :unique => player.unique, :stamp => leaderboard.daily_stamp, :points => 33})
    ScoreDaily.save(leaderboard, player, 22, 'd2')
    
    ScoreDaily.count.should == 1
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :unique => player.unique, :username => player.username, :points => 22, :data => 'd2', :stamp => leaderboard.daily_stamp, :dated => @now}).should == 1
  end
  
  it "inserts a second score for a different stamp" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score_daily, {:leaderboard_id => leaderboard.id, :unique => player.unique, :stamp => @now - 1000000, :points => 33})
    ScoreDaily.save(leaderboard, player, 22, 'd2')
    
    ScoreDaily.count.should == 2
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :points => 33, :stamp => @now - 1000000}).should == 1
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :points => 22, :stamp => leaderboard.daily_stamp}).should == 1
  end
  
  it "inserts a second score for a different unique" do
    leaderboard = FactoryGirl.build(:leaderboard)
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score_daily, {:leaderboard_id => leaderboard.id, :unique => 'u111', :stamp => leaderboard.daily_stamp, :points => 33})
    ScoreDaily.save(leaderboard, player, 22, 'd2')
    
    ScoreDaily.count.should == 2
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :points => 33, :unique => 'u111'}).should == 1
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :points => 22, :unique => player.unique}).should == 1
  end
  
  it "inserts a second score for a different leaerboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    other_id = Id.new
    player = FactoryGirl.build(:player)
    FactoryGirl.create(:score_daily, {:leaderboard_id => other_id, :unique => player.unique, :stamp => leaderboard.daily_stamp, :points => 33})
    ScoreDaily.save(leaderboard, player, 22, 'd2')
    
    ScoreDaily.count.should == 2
    ScoreDaily.count({:leaderboard_id => other_id, :points => 33}).should == 1
    ScoreDaily.count({:leaderboard_id => leaderboard.id, :points => 22}).should == 1
  end
end