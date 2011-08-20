require 'spec_helper'

describe Api::Gamma::AchievementsController, :create do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  it_ensures_a_valid_player :post, :create
  it_ensures_a_valid_achievement :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  it_ensures_achievement_belongs_to_game :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  
  it "saves the achievement" do
    achievement = FactoryGirl.create(:achievement)
    player = FactoryGirl.build(:player)
    EarnedAchievement.should_receive(:create).with(achievement, player).and_return({})
    post :create, GammaApiHelper.signed_params(@game, {:aid => achievement.id, :username => player.username, :userkey => player.userkey})
  end
  
  
  it "renders the achievement info when first time earned" do
    achievement = FactoryGirl.create(:achievement, {:points => 123, :id => Id.new})
    player = FactoryGirl.build(:player)
    EarnedAchievement.stub!(:create).with(achievement, player).and_return({})
    post :create, GammaApiHelper.signed_params(@game, {:aid => achievement.id, :username => player.username, :userkey => player.userkey})
    
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json['id'].should == achievement.id.to_s
    json['points'].should == 123
  end
  
  it "renders a blank response when already earned" do
    achievement = FactoryGirl.create(:achievement, {:points => 123, :id => Id.new})
    player = FactoryGirl.build(:player)
    
    EarnedAchievement.stub!(:create).with(achievement, player).and_return(nil)
    post :create, GammaApiHelper.signed_params(@game, {:aid => achievement.id, :username => player.username, :userkey => player.userkey})
    
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json.length.should == 0
  end
end