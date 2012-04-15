require 'spec_helper'

describe Game, :set_stat_names do
  it "sets the names and saves the game" do
    game = Game.create('ham zapper')
    game.set_stat_names(['a', 'b'])
    Game.find_one.stats.should == ['a', 'b']
  end
  
  it "truncates the name to 20 characters" do
    game = Game.create('ham zapper')
    game.set_stat_names(['a' * 20, 'b' * 21])
    Game.find_one.stats.should == ['a' * 20, 'b' * 20]
  end
  
  it "limits it to 20 values" do
    game = Game.create('ham zapper')
    game.set_stat_names(['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22'])
    Game.find_one.stats.should == ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20']
  end
end