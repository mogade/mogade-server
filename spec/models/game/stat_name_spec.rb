require 'spec_helper'

describe Game, :stat_name do
  it "returns the name of the stat at the specified index" do
    game = Game.create('ham zapper')
    game.stats = ["a", "b", "c"]
    game.stat_name(2).should == 'c'
  end
  
  it "returns a default name if the stats are null" do
    game = Game.create('ham zapper')
    game.stat_name(3).should be_nil
  end
  
  it "returns a default stat name" do
    game = Game.create('ham zapper')
    game.stats = []
    game.stat_name(2).should be_nil
  end
end