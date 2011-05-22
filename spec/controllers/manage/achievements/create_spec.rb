require 'spec_helper'

describe Manage::AchievementsController, :create do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :create
  it_ensures_developer_owns_the_game :post, :create
  
  it "does not save an invalid achievement" do
    achievement = Achievement.new
    
    Achievement.stub!(:create).and_return(achievement)
    achievement.should_receive(:valid?).and_return(false)
    post :create, {:game_id => @game.id}
  
    Achievement.count.should == 0  
  end
  
  it "saves a valid achievement" do
    post :create, {:game_id => @game.id, :name => 'ta', :description => 'an achievement description', :points => 234}
    Achievement.count({:game_id => @game.id, :name => 'ta', :description => 'an achievement description', :points => 234}).should == 1
  end
  
end