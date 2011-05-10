require 'spec_helper'

describe Score, :get_by_player do
  before :each do
    @created = 0
  end
  
  it "should get the start of the leaderboard if the player doesn't have a score" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(20)
    data = Score.get_by_player(@leaderboard, Player.new('x', 'y'), 5, LeaderboardScope::Daily)
    data[:page].should == 1
    data[:scores].count(true).should == 5
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
    scores = data[:scores].to_a
    scores[0][:points].should == highest_score
    scores[-1][:points].should == lowest_score
    
  end
  def create_yesterday_scores(count)
    create_scores(count, Score.daily_collection, LeaderboardScope::Daily, @leaderboard.yesterday_start)
  end
  def create_daily_scores(count)
    create_scores(count, Score.daily_collection, LeaderboardScope::Daily, @leaderboard.daily_start)
  end
  def create_weekly_scores(count)
    create_scores(count, Score.weekly_collection, LeaderboardScope::Weekly,  @leaderboard.weekly_start)
  end
  def create_overall_scores(count)
    create_scores(count, Score.overall_collection, LeaderboardScope::Overall)
  end
  def create_scores(count, collection, scope, dated = nil)
    count.times do |i|
      params = {:leaderboard_id => @leaderboard.id, :username => "player_#{@created}", :points => @created, :data => "data#{@created}"}
      params[:dated] = dated unless dated.nil?
      score = Score.new(params)
      collection.save(Score.map(score.attributes)) #fugly
      Rank.save(@leaderboard, scope, "punique#{@created}", @created)
      @created += 1
    end
  end
end