require 'spec_helper'

describe Asset, :find_for_game do
  it "loads the leaderboards for the specified game" do
    game_id = Id.new
    Factory.create(:asset, {:id => Id.new, :game_id => game_id, :name => 'c'})
    Factory.create(:asset, {:id => Id.new, :game_id => game_id, :name => 'a'})
    Factory.create(:asset, {:id => Id.new, :game_id => Id.new})
    Factory.create(:asset, {:id => Id.new, :game_id => game_id, :name => 'b'})
    
    assets = Asset.find_for_game(Factory.build(:game, {:id => game_id}))
    assets.length.should == 3
    assets[0].name.should == 'a'
    assets[1].name.should == 'b'
    assets[2].name.should == 'c'
  end  
end