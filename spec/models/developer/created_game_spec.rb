require 'spec_helper'

describe Developer, :created_game do
  
  it "adds the game to the developer's list of games" do
    game = FactoryGirl.build(:game)
    developer = FactoryGirl.build(:developer)
    developer.created_game!(game)
    developer.game_ids.should == [game.id]
  end

  it "saves the game with the developer" do
    game = FactoryGirl.build(:game)
    developer = FactoryGirl.build(:developer)
    developer.created_game!(game)
    Developer.count({:_id => developer.id, :game_ids => [game.id]}).should == 1
  end
  
  it "saves multiple games for the developer" do
    game1 = FactoryGirl.build(:game, {:id => Id.new})
    game2 = FactoryGirl.build(:game)
    developer = FactoryGirl.build(:developer)
    developer.created_game!(game1)
    developer.created_game!(game2)
    
    Developer.count({:_id => developer.id, :game_ids => [game1.id, game2.id]}).should == 1
  end
  
end