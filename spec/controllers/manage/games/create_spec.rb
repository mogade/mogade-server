require 'spec_helper'

describe Manage::GamesController, :create do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :create
  
  it "redirects to the index if the game is invalid" do
    post :create
    response.should redirect_to('/manage/games')
  end
  
  it "saves the game and goes to its view" do
    game = FactoryGirl.build(:game)
    
    Game.should_receive(:create).with('chicken chasers').and_return(game)
    game.should_receive(:save!)
    
    post :create, {:name => 'chicken chasers'}
    response.should redirect_to('/manage/games/' + game.id.to_s)
  end
  
  it "tells the current developer about the new game" do
    game = FactoryGirl.build(:game)
    
    Game.stub!(:create).and_return(game)
    @developer.should_receive(:created_game!).with(game)
    
    post :create, {:name => 'chicken chasers'}
  end
  
end