require 'spec_helper'

describe Api::ScoresController, :create do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_version :post, :create
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  it_ensures_a_valid_player :post, :create
  it_ensures_a_valid_leaderboard :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  it_ensures_leaderboard_belongs_to_game :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  
  it "renders an error if points are missing" do
    leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    post :create, ApiHelper.signed_params(@game, {:lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'missing required points value'
  end
  
  it "saves the score" do
    leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    Score.should_receive(:save).with(leaderboard, player, 323, 'dta').and_return({})
    post :create, ApiHelper.signed_params(@game, {:points => '323', :data => 'dta', :lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
  end
  
  
  it "renders the new rank for better scores" do
    leaderboard = Factory.create(:leaderboard)
    player = Factory.build(:player)
    Score.stub!(:save).and_return({LeaderboardScope::Daily => true, LeaderboardScope::Weekly => true, LeaderboardScope::Overall => false})
    Rank.should_receive(:get).with(leaderboard, player, [LeaderboardScope::Daily]).and_return(985)
    Rank.should_receive(:get).with(leaderboard, player, [LeaderboardScope::Weekly]).and_return(455)
    
    post :create, ApiHelper.signed_params(@game, {:points => '323', :lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json[LeaderboardScope::Daily.to_s].should == 985
    json[LeaderboardScope::Weekly.to_s].should == 455
    json[LeaderboardScope::Overall.to_s].should == 0
  end
end