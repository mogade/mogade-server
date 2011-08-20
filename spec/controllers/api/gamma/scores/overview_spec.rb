require 'spec_helper'

describe Api::Gamma::ScoresController, :overview do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_leaderboard :get, :overview
  
  
  it "gets the top score for each of the scopes" do
    leaderboard = FactoryGirl.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'blah' => 1}]}
    
    Score.should_receive(:get_by_page).with(leaderboard, 1, 3, LeaderboardScope::Yesterday).and_return({:scores => nil})
    Score.should_receive(:get_by_page).with(leaderboard, 1, 3, LeaderboardScope::Daily).and_return({:scores => nil})
    Score.should_receive(:get_by_page).with(leaderboard, 1, 3, LeaderboardScope::Weekly).and_return({:scores => nil})
    Score.should_receive(:get_by_page).with(leaderboard, 1, 3, LeaderboardScope::Overall).and_return({:scores => nil})
    get :overview, {:lid => leaderboard.id}
  end
  
  it "returns the scores without ta callback" do
    leaderboard = FactoryGirl.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'blah' => 1}]}
    
    Score.stub!(:get_by_page).and_return{|lb, page, count, scope| {:scores => scope}}
    get :overview, {:lid => leaderboard.id}
    
    response.status.should == 200
    response.body.should == '{"4":4,"1":1,"2":2,"3":3}'
  end
  
  it "returns the scores within the specific callback" do
    leaderboard = FactoryGirl.create(:leaderboard)
    scores = {:page => 4, :scores =>[{'blah' => 1}]}
    
    Score.stub!(:get_by_page).and_return{|lb, page, count, scope| {:scores => scope}}
    get :overview, {:lid => leaderboard.id, :callback => 'gotScores'}
    
    response.status.should == 200
    response.body.should == 'gotScores({"4":4,"1":1,"2":2,"3":3});'
  end
  
  it "sets output cache set when callback is used" do
    leaderboard = FactoryGirl.create(:leaderboard)
    
    Score.stub!(:get_by_page).and_return{|lb, page, count, scope| {:scores => scope}}
    get :overview, {:lid => leaderboard.id, :callback => 'gotScores'}
    
    response.headers['Cache-Control'].should == 'max-age=180, public'
  end
  
  it "does not set output cache when callback is not used" do
    leaderboard = FactoryGirl.create(:leaderboard)
    
    Score.stub!(:get_by_page).and_return{|lb, page, count, scope| {:scores => scope}}
    get :overview, {:lid => leaderboard.id}
    
    response.headers['Cache-Control'].should == 'max-age=0, private, must-revalidate'
  end
  
end