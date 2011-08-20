require 'spec_helper'

describe Manage::ErrorsController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy
  
  it "deletes the error" do
    error = FactoryGirl.create(:game_error, {:game_id => @game.id})
    delete :destroy, {:game_id => @game.id, :id => error.id.to_s}
    GameError.count.should == 0
  end
  
  it "only deletes an error that belongs to the specified game" do
    error = FactoryGirl.create(:game_error, {:game_id => Id.new})
    delete :destroy, {:game_id => @game.id, :id => error.id.to_s}
    GameError.count.should == 1
  end
  
  it "only deletes the specified error" do
    FactoryGirl.create(:game_error, {:game_id => @game.id})
    delete :destroy, {:game_id => @game.id, :id => Id.new.to_s}
    GameError.count.should == 1
  end

end