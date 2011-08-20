require 'spec_helper'

describe Api::Gamma::ScoresController, :create do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  it_ensures_a_valid_player :post, :create
  it_ensures_a_valid_leaderboard :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  it_ensures_leaderboard_belongs_to_game :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  
  it "renders an error if points are missing" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    post :create, GammaApiHelper.signed_params(@game, {:lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'missing required points value'
  end
  
  it "saves the score" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    Score.should_receive(:save).with(leaderboard, player, 323, 'dta').and_return({})
    post :create, GammaApiHelper.signed_params(@game, {:points => '323', :data => 'dta', :lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
  end
  
  it "renders rank for the score" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    
    Score.stub!(:save)
    Rank.should_receive(:get_for_score).with(leaderboard, 323).and_return('hahahah')
    
    post :create, GammaApiHelper.signed_params(@game, {:points => '323', :lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json['ranks'].should == 'hahahah'
  end
  
  it "renders the high score data" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    Score.stub!(:save).and_return('blah')
    
    post :create, GammaApiHelper.signed_params(@game, {:points => '323', :lid => leaderboard.id, :username => player.username, :userkey => player.userkey})
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json['highs'].should == 'blah'
  end
end