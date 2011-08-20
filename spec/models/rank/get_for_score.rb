require 'spec_helper'

describe Rank, :get_for_score do
  it "gets a rank from yesterday for high to low" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_yesterday_ranks(10)
    Rank.get_for_score(@leaderboard, 8, LeaderboardScope::Yesterday).should == 2
  end

  it "gets a rank from yesterday for Low to High" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_yesterday_ranks(10)
    Rank.get_for_score(@leaderboard, 0, LeaderboardScope::Yesterday).should == 1
  end

  it "gets a rank from daily for high to low" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_daily_ranks(10)
    Rank.get_for_score(@leaderboard, 15, LeaderboardScope::Daily).should == 1
  end

  it "gets a rank from daily for Low to High" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_daily_ranks(10)
    Rank.get_for_score(@leaderboard, 15, LeaderboardScope::Daily).should == 11
  end

  it "gets a rank from weekly for high to low" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_weekly_ranks(10)
    Rank.get_for_score(@leaderboard, 9, LeaderboardScope::Weekly).should == 1
  end

  it "gets a rank from weekly for Low to High" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_weekly_ranks(10)
    Rank.get_for_score(@leaderboard, 0, LeaderboardScope::Weekly).should == 1
  end

  it "gets a rank from overall for high to low" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_overall_ranks(10)
    Rank.get_for_score(@leaderboard, 5, LeaderboardScope::Overall).should == 5
  end

  it "gets a rank from overall for Low to High" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_overall_ranks(10)
    Rank.get_for_score(@leaderboard, 5, LeaderboardScope::Overall).should == 6
  end

  it "gets the ranks for all scopes" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_yesterday_ranks(2)
    add_daily_ranks(1)
    add_weekly_ranks(10)
    add_overall_ranks(4)

    ranks = Rank.get_for_score(@leaderboard, 2, nil)
    ranks[LeaderboardScope::Yesterday].should == 1
    ranks[LeaderboardScope::Daily].should == 1
    ranks[LeaderboardScope::Weekly].should == 8
    ranks[LeaderboardScope::Overall].should == 2
  end
  
  it "gets the ranks for specified scopes" do
    @leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_yesterday_ranks(2)
    add_daily_ranks(1)
    add_weekly_ranks(10)
    add_overall_ranks(4)

    ranks = Rank.get_for_score(@leaderboard, 2, [LeaderboardScope::Daily, LeaderboardScope::Weekly])
    ranks.length.should == 2
    ranks[LeaderboardScope::Daily].should == 1
    ranks[LeaderboardScope::Weekly].should == 8
  end
     
  private
  def add_yesterday_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Yesterday)
    add_ranks(count, key)
  end
  def add_daily_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Daily)
    add_ranks(count, key)
  end
  def add_weekly_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Weekly)
    add_ranks(count, key)
  end
  def add_overall_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Overall)
    add_ranks(count, key)
  end
  def add_ranks(count, key)
    count.times do |i|
      Store.redis.zadd key, i, "member#{i}"
    end
  end
end