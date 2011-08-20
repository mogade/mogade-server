require 'spec_helper'

describe Developer, :owns? do
  
  it "returns true if the developer owns the game" do
    game = FactoryGirl.build(:game)
    developer = FactoryGirl.build(:developer)
    developer.game_ids << game.id
    developer.owns?(game).should be_true
  end

  it "returns false if the developer does not own the game" do
    game = FactoryGirl.build(:game)
    developer = FactoryGirl.build(:developer)
    developer.game_ids << Id.new
    developer.owns?(game).should be_false
  end

  it "returns false if the developer does not own any games" do
    game = FactoryGirl.build(:game)
    developer = FactoryGirl.build(:developer)
    developer.owns?(game).should be_false
  end
  
end