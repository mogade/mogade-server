require 'spec_helper'

describe Api::AchievementsController, :index do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_version :get, :index
  it_ensures_a_valid_context :get, :index
  it_ensures_a_valid_player :get, :index
  
  it "gets the player's achievements" do
    player = Factory.build(:player)
    EarnedAchievement.should_receive(:earned_by_player).with(@game, player).and_return([1, 2])
    
    get :index, ApiHelper.signed_params(@game, {:username => player.username, :userkey => player.userkey})    
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json.length.should == 2
    json[0].should == 1
    json[1].should == 2
  end
  
  
  
end