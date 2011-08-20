require 'spec_helper'

describe Game, :find_by_ids do
  it "returns the found games ordered by name" do
    game1 = FactoryGirl.create(:game, {:name => 'c', :id => Id.new})
    game2 = FactoryGirl.create(:game, {:name => 'd', :id => Id.new})
    game3 = FactoryGirl.create(:game, {:name => 'a', :id => Id.new})
    game3 = FactoryGirl.create(:game, {:name => 'b', :id => Id.new})
    
    games = Game.find_by_ids([game1.id, game2.id, game3.id]).to_a
    games.length.should == 3
    games[0].should == game3
    games[1].should == game1
    games[2].should == game2
  end
end