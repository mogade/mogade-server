require 'spec_helper'

describe Leaderboard, :find_for_game do
  
  it "loads the leaderboards for the specified game" do
    game_id = Id.new
    Factory.create(:achievement, {:id => Id.new, :game_id => game_id, :name => 'c'})
    Factory.create(:achievement, {:id => Id.new, :game_id => game_id, :name => 'a'})
    Factory.create(:achievement, {:id => Id.new, :game_id => Id.new})
    Factory.create(:achievement, {:id => Id.new, :game_id => game_id, :name => 'b'})
    
    achievements = Achievement.find_for_game(Factory.build(:game, {:id => game_id}))
    achievements.length.should == 3
    achievements[0].name.should == 'a'
    achievements[1].name.should == 'b'
    achievements[2].name.should == 'c'
  end
end