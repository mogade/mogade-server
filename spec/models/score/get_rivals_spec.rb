require 'spec_helper'

describe Score, :get_rivals do  
  before :each do
    @created = 0
    @now = Time.now.utc
    Time.stub!(:now).and_return(@now)
  end
  
  it "should return an empty array if the player doesn't exist" do
    @leaderboard = FactoryGirl.create(:leaderboard)
    create_daily_scores(6)
    scores = Score.get_rivals(@leaderboard, FactoryGirl.build(:player), LeaderboardScope::Daily).to_a
    scores.length.should == 0
  end
  
  it "should return 3 players with better scores for high to low" do
    @leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    player.stub!(:unique).and_return('unique_2')
    create_daily_scores(6)
    scores = Score.get_rivals(@leaderboard, player, LeaderboardScope::Daily).to_a
    scores.length.should == 3 
    scores[0][:points].should == 5
    scores[1][:points].should == 4
    scores[2][:points].should == 3
  end
  
  it "should return available players with better scores for high to low" do
    @leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    player.stub!(:unique).and_return('unique_3')
    create_weekly_scores(6)
    scores = Score.get_rivals(@leaderboard, player, LeaderboardScope::Weekly).to_a
    scores.length.should == 2
    scores[0][:points].should == 5
    scores[1][:points].should == 4
  end
  
  it "should scores for low to high" do
    @leaderboard = FactoryGirl.create(:leaderboard, {:type => LeaderboardType::LowToHigh})
    player = FactoryGirl.build(:player)
    player.stub!(:unique).and_return('unique_3')
    create_overall_scores(6)
    scores = Score.get_rivals(@leaderboard, player, LeaderboardScope::Overall).to_a
    scores.length.should == 3
    scores[0][:points].should == 0
    scores[1][:points].should == 1
    scores[2][:points].should == 2
  end
  
  
  private
  def create_yesterday_scores(count, stamp = nil)
    create_scores(count, :daily, stamp || @leaderboard.yesterday_stamp)
  end
  def create_daily_scores(count, stamp = nil)
    create_scores(count, :daily, stamp || @leaderboard.daily_stamp)
  end
  def create_weekly_scores(count, stamp = nil)
    create_scores(count, :weekly, stamp || @leaderboard.weekly_stamp)
  end
  def create_overall_scores(count)
    create_scores(count, :overall)
  end
  def create_scores(count, scope_name, stamp = nil)
    count.times do |i|
      score_data = FactoryGirl.build(:score_data, {:points => @created, :data => "data#{@created}", :dated => @now - 100 * @created})
      score_data.stamp = stamp  unless stamp.nil?
      params = {:leaderboard_id => @leaderboard.id, :username => "player_#{@created}", :unique => "unique_#{@created}", scope_name => score_data}
      Score.new(params).save      
      @created += 1
    end
  end
end