require 'spec_helper'

describe Api::ScoresController, :index do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_version :get, :index
  it_ensures_a_valid_leaderboard :get, :index
  
  it "defaults the score, records and scope" do
    leaderboard = Factory.create(:leaderboard)
    Score.should_receive(:get).with(leaderboard, 1, 10, LeaderboardScope::Daily)
    get :index, ApiHelper.versioned({:lid => leaderboard.id})
  end
  
  it "gets the specified score, records and scope" do
    leaderboard = Factory.create(:leaderboard)
    Score.should_receive(:get).with(leaderboard, 2, 15, LeaderboardScope::Overall)
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '2', :records => '15', :scope => LeaderboardScope::Overall})
  end
  
  it "returns the scores with the specified page" do
    leaderboard = Factory.create(:leaderboard)
    scores = [{'points' => 1}]
    Score.stub!(:get).and_return(scores)
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '4'})
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json['page'].should == 4
    json['scores'].should == scores
  end
  
end