require 'spec_helper'

describe Manage::ErrorsController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index
  
  it "loads the errors" do
    GameError.should_receive(:paged).with(@game, 78)
    get :list, {:id => @game.id, :page => 78}
  end

end