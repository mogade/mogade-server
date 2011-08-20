require 'spec_helper'

describe Achievement, :create do
  it "creates a new achievement" do
    game = FactoryGirl.build(:game, {:name => 'spice finder'})
    achievement = Achievement.create('into the sand', 'ReDrUm', 234, game)
    achievement.name.should == 'into the sand'
    achievement.description.should == 'ReDrUm'
    achievement.points.should == 234
    achievement.game_id.should == game.id
  end
end