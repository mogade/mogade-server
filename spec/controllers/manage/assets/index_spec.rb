require 'spec_helper'

describe Manage::AssetsController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index
  
  it "loads the assets and renders the view" do
    assets = [Factory.build(:asset)]
    
    Asset.should_receive(:find_for_game).with(@game).and_return(assets)
    get :index, {:id => @game.id}
    
    assigns[:assets].to_a.should == assets
    response.should render_template('manage/assets/index')
  end
  
end