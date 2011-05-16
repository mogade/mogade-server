require 'spec_helper'

describe Game, :update do
  it "updates the game" do
    game = Factory.build(:game, {:name => 'old name'})
    game.update('new name')
    game.name.should == 'new name'
    Game.count({:_id => game.id, :name => 'new name'}).should == 1
  end
end