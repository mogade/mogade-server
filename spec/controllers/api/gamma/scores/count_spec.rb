require 'spec_helper'

describe Api::Gamma::ScoresController, :count do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_leaderboard :get, :count
  
  it "gets the counts from the ranks" do
    leaderboard = FactoryGirl.create(:leaderboard)
    Rank.should_receive(:count).with(leaderboard, LeaderboardScope::Weekly)
    get :count, {:lid => leaderboard.id, :scope => LeaderboardScope::Weekly}
  end
  
  it "gets the counts from the ranks" do
    leaderboard = FactoryGirl.create(:leaderboard)
    Rank.stub!(:count).and_return(2394)
    get :count, {:lid => leaderboard.id, :scope => LeaderboardScope::Weekly}
    response.status.should == 200
    
    json = ActiveSupport::JSON.decode(response.body)
    json.should == 2394
  end
end