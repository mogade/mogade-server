require 'spec_helper'

describe Score, 'get scores' do
  before :each do
    @created = 0
  end
  
  it "should start at the specified page" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(6)
    scores = Score.get(@leaderboard, 2, 4, LeaderboardScope::Daily).to_a
    scores[0][:points].should == 1
    scores[1][:points].should == 0
  end
  
  it "should limit the results to the specified number" do
    @leaderboard = Factory.create(:leaderboard)
    create_weekly_scores(4)
    scores = Score.get(@leaderboard, 1, 2, LeaderboardScope::Weekly).to_a
    scores.length.should == 2
  end

  it "should limit to 50 records regardless of what was specified" do
    @leaderboard = Factory.create(:leaderboard)
    create_yesterday_scores(60)
    scores = Score.get(@leaderboard, 1, 75, LeaderboardScope::Yesterday).to_a
    scores.length.should == 50
  end
    
  it "should get the scores ordered by points from high to low" do
    @leaderboard = Factory.create(:leaderboard)
    create_overall_scores(3)
    scores = Score.get(@leaderboard, 1, 10, LeaderboardScope::Overall).to_a
    scores[0][:points].should == 2
    scores[1][:points].should == 1
    scores[2][:points].should == 0
  end
  
  it "should get all the fields" do
    @leaderboard = Factory.create(:leaderboard)
    create_overall_scores(1)
    scores = Score.get(@leaderboard, 1, 1, LeaderboardScope::Overall).to_a
    scores[0][:points].should == 0
    scores[0][:username].should == 'player_0'
    scores[0][:data].should == 'data0'
    scores[0].length.should == 3
  end
  
  it "should limit the daily scores to today" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(2)
    create_daily_scores(2, @leaderboard.daily_start - 86400)
    scores = Score.get(@leaderboard, 1, 10, LeaderboardScope::Daily).to_a
    scores.length.should == 2
    scores[0][:points].should == 1
    scores[1][:points].should == 0
  end
  
  it "should limit yesterday's scores to yesterday" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(2)
    create_daily_scores(2, @leaderboard.daily_start - 86400)
    scores = Score.get(@leaderboard, 1, 10, LeaderboardScope::Yesterday).to_a
    scores.length.should == 2
    scores[0][:points].should == 3
    scores[1][:points].should == 2
  end
  
  it "should limit the weekly scores to this week" do
    @leaderboard = Factory.create(:leaderboard)
    create_weekly_scores(4, @leaderboard.weekly_start - 2)
    create_weekly_scores(2)
    scores = Score.get(@leaderboard, 1, 10, LeaderboardScope::Weekly).to_a
    scores.length.should == 2
    scores[0][:points].should == 5
    scores[1][:points].should == 4
  end
  
  
  private
  def create_yesterday_scores(count, dated = nil)
    create_scores(count, Score.daily_collection, dated || @leaderboard.yesterday_start)
  end
  def create_daily_scores(count, dated = nil)
    create_scores(count, Score.daily_collection, dated || @leaderboard.daily_start)
  end
  def create_weekly_scores(count, dated = nil)
    create_scores(count, Score.weekly_collection, dated || @leaderboard.weekly_start)
  end
  def create_overall_scores(count)
    create_scores(count, Score.overall_collection)
  end
  def create_scores(count, collection, dated = nil)
    count.times do |i|
      params = {:leaderboard_id => @leaderboard.id, :username => "player_#{@created}", :unique => "unique_#{@created}", :points => @created, :data => "data#{@created}"}
      params[:dated] = dated unless dated.nil?
      score = Score.new(params)
      collection.save(Score.map(score.attributes)) #fugly
      @created += 1
    end
  end
end