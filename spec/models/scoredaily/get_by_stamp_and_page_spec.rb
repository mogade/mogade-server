require 'spec_helper'

describe ScoreDaily, 'get by stamp and page' do
  before :each do
    @now = Time.now
    Time.stub!(:now).and_return(@now)
    @created = 0
  end

  it "returns the leaderboard from high to low" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    create_scores(10, leaderboard.yesterday_stamp, leaderboard)
    
    scores = ScoreDaily.get_by_stamp_and_page(leaderboard, leaderboard.yesterday_stamp, 5, 0).to_a
    scores[0][:points].should == 9
    scores[4][:points].should == 5
  end
  
  it "returns the leaderboard from low to high" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    create_scores(10, leaderboard.yesterday_stamp, leaderboard )
    
    scores = ScoreDaily.get_by_stamp_and_page(leaderboard, leaderboard.yesterday_stamp, 3, 0).to_a
    scores[0][:points].should == 0
    scores[2][:points].should == 2
  end
  
  it "returns the scores for the specific leaderboard" do
    leaderboard1 = FactoryGirl.build(:leaderboard, {:id => Id.new})
    leaderboard2 = FactoryGirl.build(:leaderboard, {:id => Id.new})
    create_scores(5, leaderboard1.yesterday_stamp, leaderboard1)
    create_scores(5, leaderboard1.yesterday_stamp, leaderboard2)
    
    scores = ScoreDaily.get_by_stamp_and_page(leaderboard1, leaderboard1.yesterday_stamp, 20, 0).to_a
    scores.length.should == 5
    scores[0][:points].should == 4
  end
  
  it "returns the scores for the specific stamp" do
    leaderboard = FactoryGirl.build(:leaderboard, {:id => Id.new})
    create_scores(5, leaderboard.yesterday_stamp, leaderboard)
    create_scores(5, leaderboard.daily_stamp, leaderboard)
  
    scores = ScoreDaily.get_by_stamp_and_page(leaderboard, leaderboard.daily_stamp, 20, 0).to_a
    scores.length.should == 5
    scores[0][:points].should == 9
  end
  
  it "returns all the data" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    create_scores(1, leaderboard.yesterday_stamp, leaderboard )
    
    score = ScoreDaily.get_by_stamp_and_page(leaderboard, leaderboard.yesterday_stamp, 1, 0).to_a[0]
    score[:points].should == 0
    score[:username].should == 'player_0'
    score[:data].should == 'd_0'
    score[:dated].to_s.should == @now.to_s
  end

  def create_scores(count, stamp, leaderboard)
    count.times do |i|
      params = {:leaderboard_id => leaderboard.id, :username => "player_#{@created}", :unique => "unique_#{@created}", :data => "d_#{@created}", :points => @created, :stamp => stamp, :dated => @now - (@created * 100)}
      ScoreDaily.new(params).save      
      @created += 1
    end
  end
end