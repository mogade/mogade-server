require 'spec_helper'

describe Manage::ErrorsController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index
  
  it "loads the number of errors for the game" do
    FactoryGirl.create(:game_error, {:game_id => @game.id, :hash => 'h1'})
    FactoryGirl.create(:game_error, {:game_id => @game.id, :hash => 'h2'})
    FactoryGirl.create(:game_error, {:game_id => Id.new, :hash => 'h3'})
    
    get :index, {:id => @game.id}
    assigns[:count].should == 2
    response.should render_template('manage/errors/index')
  end

end