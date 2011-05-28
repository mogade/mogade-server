require 'spec_helper'

describe Manage::ErrorsController, :list do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :list
  it_ensures_developer_owns_the_game :get, :list
  
  it "loads the errors" do
    GameError.should_receive(:paged).with(@game, 78)
    get :list, {:id => @game.id, :page => 78}
  end

end