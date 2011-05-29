require 'spec_helper'

describe Score, :get_by_player do
  before :each do
    @created = 0
    @now = Time.now.utc
    Time.stub!(:now).and_return(@now)
  end
  
  it "should get the start of the leaderboard if the player doesn't have a score" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(20)
    data = Score.get_by_player(@leaderboard, Player.new('x', 'y'), 5, LeaderboardScope::Daily)
    data[:page].should == 1
    data[:scores].length.should == 5
  end
 
  it "should return yesterdays's leaderboard from the player's position" do
    @leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    create_yesterday_scores(20)
    
    player.stub!(:unique).and_return('punique19')
    data = Score.get_by_player(@leaderboard, player, 4, LeaderboardScope::Yesterday)    
    assert_data(data, 1, 19, 16)
  end
   
  it "should return the daily leaderboard from the player's position" do
    @leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    create_daily_scores(20)
    
    player.stub!(:unique).and_return('punique10')
    data = Score.get_by_player(@leaderboard, player, 5, LeaderboardScope::Daily)    
    assert_data(data, 2, 14, 10)
  end
  
  it "should return the weekly leaderboard from the player's position" do
    @leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    create_weekly_scores(20)
    
    player.stub!(:unique).and_return('punique9')
    data = Score.get_by_player(@leaderboard, player, 5, LeaderboardScope::Weekly)
    
    assert_data(data, 3, 9, 5)
  end
  
  it "should return the overall leaderboard from the player's position" do
    @leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    create_overall_scores(20)
    
    player.stub!(:unique).and_return('punique0')
    data = Score.get_by_player(@leaderboard, player, 6, LeaderboardScope::Overall)
    
    assert_data(data, 4, 1, 0)
  end  
  
  private
  def assert_data(data, page, highest_score, lowest_score)
    data[:page].should == page
    scores = data[:scores]
    scores[0][:points].should == highest_score
    scores[-1][:points].should == lowest_score
    
  end
  def create_yesterday_scores(count, stamp = nil)
    create_scores(count, :daily, LeaderboardScope::Daily, stamp || @leaderboard.yesterday_stamp)
  end
  def create_daily_scores(count, stamp = nil)
    create_scores(count, :daily, LeaderboardScope::Daily, stamp || @leaderboard.daily_stamp)
  end
  def create_weekly_scores(count, stamp = nil)
    create_scores(count, :weekly, LeaderboardScope::Weekly, stamp || @leaderboard.weekly_stamp)
  end
  def create_overall_scores(count)
    create_scores(count, :overall, LeaderboardScope::Overall)
  end
  def create_scores(count, scope_name, scope, stamp = nil)
    count.times do |i|
      score_data = Factory.build(:score_data, {:points => @created, :data => "data#{@created}", :dated => @now - 100 * @created})
      score_data.stamp = stamp  unless stamp.nil?
      params = {:leaderboard_id => @leaderboard.id, :username => "player_#{@created}", :unique => "unique_#{@created}", scope_name => score_data}
      Score.new(params).save      
      Rank.save(@leaderboard, scope, "punique#{@created}", @created)
      @created += 1
    end
  end
end