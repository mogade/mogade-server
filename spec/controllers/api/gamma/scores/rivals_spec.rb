require 'spec_helper'

describe Api::Gamma::ScoresController, :rivals do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_player :get, :rivals
  it_ensures_a_valid_leaderboard :get, :rivals, Proc.new { {:username => 'leto', :userkey => 'one'} }
  
  it "gets player's rival" do
    leaderboard = FactoryGirl.create(:leaderboard)
    player = FactoryGirl.build(:player)
    
    Score.should_receive(:get_rivals).with(leaderboard, player, 3).and_return('h@ck')
    get :rivals, {:lid => leaderboard.id, :scope => '3', :username => player.username, :userkey => player.userkey}
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json.should == 'h@ck'
  end
end