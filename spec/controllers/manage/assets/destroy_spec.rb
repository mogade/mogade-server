require 'spec_helper'

describe Manage::AssetsController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy, Proc.new { 
    asset = FactoryGirl.build(:asset, {:game_id => ManageHelper.game_id})
    Asset.stub!(:find_by_id).and_return(asset)
    {:id => asset.id} 
  }
  
  it "verifies that the asset belongs to the game" do
    asset = FactoryGirl.build(:asset, {:game_id => Id.new})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    
    delete :destroy, {:id => asset.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end
  
  it "destroys the asset" do
    asset = FactoryGirl.build(:asset, {:game_id => @game.id})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    asset.should_receive(:destroy)
    delete :destroy, {:id => asset.id, :game_id => @game.id}
  end
  
  it "redirect to index with message" do
    asset = FactoryGirl.build(:asset, {:game_id => @game.id})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    
    delete :destroy, {:id => asset.id, :game_id => @game.id}
    
    flash[:info].should == "#{asset.name} was successfully deleted"
    response.should redirect_to('/manage/assets?id=' + @game.id.to_s)
  end
end