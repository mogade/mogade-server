require 'spec_helper'

describe Manage::AssetsController, :update do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :put, :update
  it_ensures_developer_owns_the_game :put, :update, Proc.new { 
    asset = FactoryGirl.build(:asset, {:game_id => ManageHelper.game_id})
    Asset.stub!(:find_by_id).and_return(asset)
    {:id => asset.id} 
  }
  
  it "verifies that the asset belongs to the game" do
    asset = FactoryGirl.build(:asset, {:game_id => Id.new})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    
    put :update, {:id => asset.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end
  
  it "replaces the file with a new one" do    
    asset = FactoryGirl.build(:asset, {:game_id => @game.id, :file => 'existing'})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    FileStorage.should_receive(:replace_asset).with('existing', 'new').and_return('the new name')
    
    put :update, {:id => asset.id, :game_id => @game.id, :name => 'n', :type => '4', :meta => 'm', :fileChoice => '2', :file => 'new'}
    asset.file.should == 'the new name'
  end
  
  it "deletes the file" do
    asset = FactoryGirl.build(:asset, {:game_id => @game.id, :file => 'existing'})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    FileStorage.should_receive(:delete_asset).with('existing')
    
    put :update, {:id => asset.id, :game_id => @game.id, :name => 'n', :type => '4', :meta => 'm', :fileChoice => '3'}
    asset.file.should be_nil
  end


  it "updates the asset" do
    asset = FactoryGirl.build(:asset, {:game_id => @game.id})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    asset.should_receive(:update).with('n', 4, 'm')
    put :update, {:id => asset.id, :game_id => @game.id, :name => 'n', :type => '4', :meta => 'm'}
  end
  
  it "redirect to index " do
    asset = FactoryGirl.build(:asset, {:game_id => @game.id})
    Asset.stub!(:find_by_id).with(asset.id).and_return(asset)
    
    put :update, {:id => asset.id, :game_id => @game.id}
    
    response.should redirect_to('/manage/assets?id=' + @game.id.to_s)
  end
end