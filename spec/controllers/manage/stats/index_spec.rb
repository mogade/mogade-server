require 'spec_helper'

describe Manage::StatsController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index

  it "returns the weekly unique " do
    data = {:stats => true}
    Stat.should_receive(:weekly_unique).with(@game).and_return(45)
    get :index, {:id => @game.id}
    assigns[:weekly_unique].should == 45
  end
  
end