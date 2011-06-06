require 'spec_helper'

describe Profile, :load_for_game do
  
  it "returns the existing profile" do
    game = Factory.build(:game)
    profile = Factory.create(:profile, {:id => game.id})    
    Profile.load_for_game(game).should == profile
  end
  
  it "returns a new profile based on the game" do
    game = Factory.build(:game, {:name => 'a name!'})
    profile = Profile.load_for_game(game)
    profile.name.should == 'a name!'
    profile.enabled.should be_false
    profile.id.should == game.id
  end
end