require 'spec_helper'

describe Api::Gamma::ScoresController, :index do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_leaderboard :get, :index
  
  it "defaults the score, records and scope" do
    leaderboard = FactoryGirl.create(:leaderboard)
    Score.should_receive(:get_by_page).with(leaderboard, 1, 10, LeaderboardScope::Daily)
    get :index, {:lid => leaderboard.id}
  end
  
  it "gets the specified score, records and scope" do
    leaderboard = FactoryGirl.create(:leaderboard)
    Score.should_receive(:get_by_page).with(leaderboard, 2, 15, LeaderboardScope::Overall)
    get :index, {:lid => leaderboard.id, :page => '2', :records => '15', :scope => LeaderboardScope::Overall}
  end
  
  it "gets the specified score per player when the player is specified" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = Player.new('leto2', 'ghanima')
    Player.should_receive(:new).with('leto2', 'ghanima').and_return(player)
    Score.should_receive(:get_by_player).with(leaderboard, player, 15, LeaderboardScope::Overall)
    get :index, {:lid => leaderboard.id, :username => 'leto2', :userkey => 'ghanima', :page => '2', :records => '15', :scope => LeaderboardScope::Overall}
  end
  
  it "returns the scores with the specified page" do
    leaderboard = FactoryGirl.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'points' => 1}]}
    
    Score.stub!(:get_by_page).and_return(scores)
    get :index, {:lid => leaderboard.id, :page => '4'}
    response.status.should == 200
    
    json = ActiveSupport::JSON.decode(response.body)
    json['page'].should == 4
    json['scores'].should == scores[:scores]
  end
  
  it "returns only the player's score" do
    leaderboard = FactoryGirl.create(:leaderboard)
    score = FactoryGirl.build(:score, {:daily => FactoryGirl.build(:score_data, {:points => 9000, :data => "it's over"})})
    player = Player.new('leto2', 'ghanima')
    Player.should_receive(:new).with('leto2', 'ghanima').and_return(player)
    Score.should_receive(:load).with(leaderboard, player).and_return(score)
    get :index, {:lid => leaderboard.id, :username => 'leto2', :userkey => 'ghanima', :page => '2', :records => '1', :scope => LeaderboardScope::Daily}
    
    json = ActiveSupport::JSON.decode(response.body)
    json['points'].should == 9000
    json['data'].should == "it's over"
    json['username'].should == 'leto2'
  end
  
  it "returns the scores within the specific callback" do
    leaderboard = FactoryGirl.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'blah' => 1}]}
    
    Score.stub!(:get_by_page).and_return(scores)
    get :index, {:lid => leaderboard.id, :page => '4', :callback => 'gotScores'}
    
    response.status.should == 200
    response.body.should == 'gotScores({"page":4,"scores":[{"blah":1}]});'
  end
  
  it "sets output cache set when callback is used" do
    leaderboard = FactoryGirl.create(:leaderboard)
    
    Score.stub!(:get_by_page).and_return({})
    get :index, {:lid => leaderboard.id, :page => '4', :callback => 'gotScores'}
    
    response.headers['Cache-Control'].should == 'max-age=180, public'
  end
  
  it "does not set output cache when callback is not used" do
    leaderboard = FactoryGirl.create(:leaderboard)
    
    Score.stub!(:get_by_page).and_return({})
    get :index, {:lid => leaderboard.id, :page => '4'}
    
    response.headers['Cache-Control'].should == 'max-age=0, private, must-revalidate'
  end
  
  it "gets a score with the player" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    score = FactoryGirl.build(:score, {:daily => FactoryGirl.build(:score_data, {:points => 9000, :data => "it's over"})})
    
    Score.should_receive(:get_by_page).with(leaderboard, 2, 10, LeaderboardScope::Daily).and_return('scores')
    Rank.should_receive(:get_for_player).with(leaderboard, player.unique, LeaderboardScope::Daily).and_return('rank')
    Score.should_receive(:load).with(leaderboard, player).and_return(score)

    get :index, {:lid => leaderboard.id, :username => player.username, :userkey => player.userkey, :page => '2', :records => '10', :scope => LeaderboardScope::Daily, :with_player => 'true'} 
    json = ActiveSupport::JSON.decode(response.body)
    json['scores'].should == 'scores'
    json['rank'].should == 'rank'
    json['player']['points'].should == 9000
    json['player']['data'].should == "it's over"
    json['player']['username'].should == 'leto'
  end
  
end