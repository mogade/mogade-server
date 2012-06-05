require 'spec_helper'

describe Twitter, :disable do
  it "removes the entry" do
    game = FactoryGirl.build(:game)
    FactoryGirl.create(:twitter, {:game_id => game.id})
    Twitter.disable(game)
    Twitter.count.should == 0
  end
end