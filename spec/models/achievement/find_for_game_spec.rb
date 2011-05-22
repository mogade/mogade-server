require 'spec_helper'

describe Achievement, :find_for_game do
  
  it "loads the achievemnets for the specified game" do
    game_id = Id.new
    Factory.create(:leaderboard, {:id => Id.new, :game_id => game_id, :name => 'c'})
    Factory.create(:leaderboard, {:id => Id.new, :game_id => game_id, :name => 'a'})
    Factory.create(:leaderboard, {:id => Id.new, :game_id => Id.new})
    Factory.create(:leaderboard, {:id => Id.new, :game_id => game_id, :name => 'b'})
    
    leaderboards = Leaderboard.find_for_game(Factory.build(:game, {:id => game_id}))
    leaderboards.length.should == 3
    leaderboards[0].name.should == 'a'
    leaderboards[1].name.should == 'b'
    leaderboards[2].name.should == 'c'
  end
end