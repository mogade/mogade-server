require 'spec_helper'

describe Manage::GamesController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy
  
  it "destroys the game" do
    @game.should_receive(:destroy)
    delete :destroy, {:id => @game.id}
  end
  
  it "redirect to index with message" do
    delete :destroy, {:id => @game.id}
    flash[:info].should == "#{@game.name} was successfully deleted"
    response.should redirect_to('/manage/games')
  end
end