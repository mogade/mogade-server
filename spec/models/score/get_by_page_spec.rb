require 'spec_helper'

describe Score, :get_by_page do
  before :each do
    @created = 0
    @now = Time.now.utc
    Time.stub!(:now).and_return(@now)
  end
  
  it "should start at the specified page" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(6)
    scores = Score.get_by_page(@leaderboard, 2, 4, LeaderboardScope::Daily)[:scores].to_a
    scores[0][:points].should == 1
    scores[1][:points].should == 0
  end
  
  it "should limit the results to the specified number" do
    @leaderboard = Factory.create(:leaderboard)
    create_weekly_scores(4)
    scores = Score.get_by_page(@leaderboard, 1, 2, LeaderboardScope::Weekly)[:scores].to_a
    scores.length.should == 2
  end
  
  it "should limit to 50 records regardless of what was specified" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(60)
    scores = Score.get_by_page(@leaderboard, 1, 75, LeaderboardScope::Daily)[:scores].to_a
    scores.length.should == 50
  end
    
  it "should get the scores ordered by points from high to low" do
    @leaderboard = Factory.create(:leaderboard)
    create_overall_scores(3)
    scores = Score.get_by_page(@leaderboard, 1, 10, LeaderboardScope::Overall)[:scores].to_a
    scores[0][:points].should == 2
    scores[1][:points].should == 1
    scores[2][:points].should == 0
  end
  
  it "should get the scores ordered by points from low to high" do
    @leaderboard = Factory.create(:leaderboard, {:type => LeaderboardType::LowToHigh})
    create_overall_scores(3)
    scores = Score.get_by_page(@leaderboard, 1, 10, LeaderboardScope::Overall)[:scores].to_a
    scores[0][:points].should == 0
    scores[1][:points].should == 1
    scores[2][:points].should == 2
  end
  
  it "should get all the fields" do
    @leaderboard = Factory.create(:leaderboard)
    create_overall_scores(1)
    scores = Score.get_by_page(@leaderboard, 1, 1, LeaderboardScope::Overall)[:scores].to_a
    scores[0][:points].should == 0
    scores[0][:username].should == 'player_0'
    scores[0][:data].should == 'data0'
    scores[0][:dated].to_i.should == @now.to_i
    scores[0].length.should == 4
  end
  
  it "should limit the daily scores to today" do
    @leaderboard = Factory.create(:leaderboard)
    create_daily_scores(2)
    create_daily_scores(2, @leaderboard.daily_stamp - 86400)
    scores = Score.get_by_page(@leaderboard, 1, 10, LeaderboardScope::Daily)[:scores].to_a
    scores.length.should == 2
    scores[0][:points].should == 1
    scores[1][:points].should == 0
  end
  
  it "relies on the ScoreDaily for yesterday's scope" do
    @leaderboard = Factory.create(:leaderboard)
    ScoreDaily.should_receive(:get_by_stamp_and_page).with(@leaderboard, @leaderboard.yesterday_stamp, 10, 0).and_return([1, 2, 3])
    r = Score.get_by_page(@leaderboard, 1, 10, LeaderboardScope::Yesterday)
    r[:scores].should == [1,2,3]
    r[:page].should == 1
  end
  
  it "should limit the weekly scores to this week" do
    @leaderboard = Factory.create(:leaderboard)
    create_weekly_scores(4, @leaderboard.weekly_stamp - 2)
    create_weekly_scores(2)
    scores = Score.get_by_page(@leaderboard, 1, 10, LeaderboardScope::Weekly)[:scores].to_a
    scores.length.should == 2
    scores[0][:points].should == 5
    scores[1][:points].should == 4
  end
  
  it "should set the page" do
    @leaderboard = Factory.create(:leaderboard)
    Score.get_by_page(@leaderboard, 32, 10, LeaderboardScope::Weekly)[:page].should == 32
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
      score_data = Factory.build(:score_data, {:points => @created, :data => "data#{@created}", :dated => @now - 100 * @created})
      score_data.stamp = stamp  unless stamp.nil?
      params = {:leaderboard_id => @leaderboard.id, :username => "player_#{@created}", :unique => "unique_#{@created}", scope_name => score_data}
      Score.new(params).save      
      @created += 1
    end
  end
end