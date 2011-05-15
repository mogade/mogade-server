require 'spec_helper'

describe Manage::GamesController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  
  it "loads the developer's games" do
    @developer.game_ids << Id.new
    @developer.game_ids << Id.new
    games = [Factory.build(:game), Factory.build(:game)]
    
    Game.should_receive(:find_by_ids).with(@developer.game_ids).and_return(games)
    get :index
    
    response.should render_template('manage/games/index')
    assigns[:games].to_a.should == games
  end
  
end