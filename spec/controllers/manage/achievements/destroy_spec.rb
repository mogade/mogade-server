require 'spec_helper'

describe Manage::AchievementsController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy, Proc.new { 
    achievement = Factory.build(:achievement, {:game_id => ManageHelper.game_id})
    Achievement.stub!(:find_by_id).and_return(achievement)
    {:id => achievement.id} 
  }
  
  it "verifies that the achievement belongs to the game" do
    achievement = Factory.build(:achievement, {:game_id => Id.new})
    Achievement.stub!(:find_by_id).with(achievement.id).and_return(achievement)
    
    delete :destroy, {:id => achievement.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end
  
  it "destroys the achievement" do
    achievement = Factory.build(:achievement, {:game_id => @game.id})
    Achievement.stub!(:find_by_id).with(achievement.id).and_return(achievement)
    achievement.should_receive(:destroy)
    delete :destroy, {:id => achievement.id, :game_id => @game.id}
  end
  
  it "redirect to index with message" do
    achievement = Factory.build(:achievement, {:game_id => @game.id})
    Achievement.stub!(:find_by_id).with(achievement.id).and_return(achievement)
    
    delete :destroy, {:id => achievement.id, :game_id => @game.id}
    
    flash[:info].should == "#{achievement.name} was successfully deleted"
    response.should redirect_to('/manage/achievements?id=' + @game.id.to_s)
  end
end