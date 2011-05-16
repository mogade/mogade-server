require 'spec_helper'

describe Manage::GamesController, :update do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :put, :update
  it_ensures_developer_owns_the_game :put, :update
  
  it "updates the game" do
    @game.should_receive(:update!).with('chicken run')
    put :update, {:id => @game.id, :name => 'chicken run'}
  end
  
  it "renders a success message" do
    put :update, {:id => @game.id, :name => 'chicken run'}
    json = ActiveSupport::JSON.decode(response.body)
    json['saved'].should == true
  end
end