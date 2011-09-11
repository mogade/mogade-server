require 'spec_helper'

describe Api::Gamma::AchievementsController, :index do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :get, :index
  
  
  it "gets the game's achievements" do
    id = Id.new
    player = FactoryGirl.build(:player)
    Achievement.should_receive(:find_for_game).with(@game, true).and_return([{:_id => id, :c => 'a'}])
    
    get :index, GammaApiHelper.params(@game)    
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json.length.should == 1
    json[0].should == {'c' => 'a', 'key' => id.to_s}
  end

  it "gets the player's achievements" do
    player = FactoryGirl.build(:player)
    EarnedAchievement.should_receive(:earned_by_player).with(@game, player).and_return([1, 2])
    
    get :index, GammaApiHelper.signed_params(@game, {:username => player.username, :userkey => player.userkey})    
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json.length.should == 2
    json[0].should == "1"
    json[1].should == "2"
  end
  
end