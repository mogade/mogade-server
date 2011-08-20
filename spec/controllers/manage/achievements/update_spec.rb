require 'spec_helper'

describe Manage::AchievementsController, :update do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :put, :update
  it_ensures_developer_owns_the_game :put, :update, Proc.new { 
    achievement = FactoryGirl.build(:achievement, {:game_id => ManageHelper.game_id})
    Achievement.stub!(:find_by_id).and_return(achievement)
    {:id => achievement.id} 
  }
  
  it "verifies that the achievement belongs to the game" do
    achievement = FactoryGirl.build(:achievement, {:game_id => Id.new})
    Achievement.stub!(:find_by_id).with(achievement.id).and_return(achievement)
    
    put :update, {:id => achievement.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end
  
  it "updates the achievement" do
    achievement = FactoryGirl.build(:achievement, {:game_id => @game.id})
    Achievement.stub!(:find_by_id).with(achievement.id).and_return(achievement)
    achievement.should_receive(:update).with('n', 'd', 2)
    put :update, {:id => achievement.id, :game_id => @game.id, :name => 'n', :description => 'd', :points => 2}
  end
  
  it "redirect to index " do
    achievement = FactoryGirl.build(:achievement, {:game_id => @game.id})
    Achievement.stub!(:find_by_id).with(achievement.id).and_return(achievement)
    
    put :update, {:id => achievement.id, :game_id => @game.id}
    
    response.should redirect_to('/manage/achievements?id=' + @game.id.to_s)
  end
end