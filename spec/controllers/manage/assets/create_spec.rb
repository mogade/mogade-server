require 'spec_helper'

describe Manage::AssetsController, :create do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :create
  it_ensures_developer_owns_the_game :post, :create
  
  it "does not save an invalid asset" do
    asset = Asset.new
    
    Asset.stub!(:create).and_return(asset)
    asset.should_receive(:valid?).and_return(false)
    post :create, {:game_id => @game.id}
  
    Asset.count.should == 0  
  end
  
  it "saves a valid asset" do
    post :create, {:game_id => @game.id, :name => 'tab', :type => '4', :meta => 'my meta'}
    Asset.count({
      :game_id => @game.id, 
      :name => 'tab', 
      :type => 4, 
      :meta => 'my meta'}).should == 1
  end
  
  it "redirects to index page" do
    post :create, {:game_id => @game.id}
    response.should redirect_to('http://test.host/manage/assets?id=' + @game.id.to_s)
  end
end