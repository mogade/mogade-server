require 'spec_helper'

describe Api::ScoresController, :index do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_version :get, :index
  it_ensures_a_valid_leaderboard :get, :index
  
  it "defaults the score, records and scope" do
    leaderboard = Factory.create(:leaderboard)
    Score.should_receive(:get_by_page).with(leaderboard, 1, 10, LeaderboardScope::Daily)
    get :index, ApiHelper.versioned({:lid => leaderboard.id})
  end
  
  it "gets the specified score, records and scope" do
    leaderboard = Factory.create(:leaderboard)
    Score.should_receive(:get_by_page).with(leaderboard, 2, 15, LeaderboardScope::Overall)
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '2', :records => '15', :scope => LeaderboardScope::Overall})
  end
  
  it "gets the specified score per player when the player is specified" do
    leaderboard = Factory.create(:leaderboard)
    player = Player.new('leto2', 'ghanima')
    Player.should_receive(:new).with('leto2', 'ghanima').and_return(player)
    Score.should_receive(:get_by_player).with(leaderboard, player, 15, LeaderboardScope::Overall)
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :username => 'leto2', :userkey => 'ghanima', :page => '2', :records => '15', :scope => LeaderboardScope::Overall})
  end
  
  it "returns the scores with the specified page" do
    leaderboard = Factory.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'points' => 1}]}
    
    Score.stub!(:get_by_page).and_return(scores)
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '4'})
    response.status.should == 200
    
    json = ActiveSupport::JSON.decode(response.body)
    json['page'].should == 4
    json['scores'].should == scores[:scores]
  end
  
  it "returns the scores within the specific callback" do
    leaderboard = Factory.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'blah' => 1}]}
    
    Score.stub!(:get_by_page).and_return(scores)
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '4', :callback => 'gotScores'})
    
    response.status.should == 200
    response.body.should == 'gotScores({"page":4,"scores":[{"blah":1}]});'
  end
  
  it "sets output cache set when callback is used" do
    leaderboard = Factory.create(:leaderboard)
    
    Score.stub!(:get_by_page).and_return({})
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '4', :callback => 'gotScores'})
    
    response.headers['Cache-Control'].should == 'public, max-age=300'
  end
  
  it "does not set output cache when callback is not used" do
    leaderboard = Factory.create(:leaderboard)
    
    Score.stub!(:get_by_page).and_return({})
    get :index, ApiHelper.versioned({:lid => leaderboard.id, :page => '4'})
    
    response.headers['Cache-Control'].should == 'max-age=0, private, must-revalidate'
  end
  
end