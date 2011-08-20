require 'spec_helper'

describe Score, 'save overall' do
  before(:each) do
    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end

  it "saves a new score if the player doesn't have a score" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    Score.save(@leaderboard, @player, 100)
    score_should_exist(100)
  end

  it "saves a score if the player's current overall is lower than the new one" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    create_high_score(99)
  
    Score.save(@leaderboard, @player, 100)
    score_should_exist(100)
  end
  
  it "does not save the score if the user's current overall is higher than the new one" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    create_high_score(150)
    
    Score.save(@leaderboard, @player, 149)
    score_should_exist(150)
  end
  
  it "saves the rank if the player's new score is better" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    create_high_score(99)
    #either I, or rspec, suck..go ahead, try to do this without the next two stupid lines
    Rank.should_receive(:save).with(@leaderboard, LeaderboardScope::Daily, @player.unique, 100)
    Rank.should_receive(:save).with(@leaderboard, LeaderboardScope::Weekly, @player.unique, 100)
    Rank.should_receive(:save).with(@leaderboard, LeaderboardScope::Overall, @player.unique, 100)
    Score.save(@leaderboard, @player, 100)
  end
  
  it "does not save the rank if the player's current score is better" do
    @player = FactoryGirl.build(:player)
    @leaderboard = FactoryGirl.build(:leaderboard)
    create_high_score(150)
    Rank.should_not_receive(:save).with(anything(), LeaderboardScope::Overall, anything(), anything())
    Score.save(@leaderboard, @player, 149)
  end
  
  def score_should_exist(points)
    selector = {:lid => @leaderboard.id, :un => @player.username, :u => @player.unique, :uk => @player.userkey, 'o.p' => points, 'o.dt' => @now}
    Score.count(selector).should == 1
  end
  def create_high_score(points)
    FactoryGirl.create(:score, {:leaderboard_id => @leaderboard.id, :username => @player.username, :userkey => @player.userkey, :unique => @player.unique, :overall => FactoryGirl.build(:score_data, {:points => points,  :dated => @now})})
  end
end