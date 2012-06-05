require 'spec_helper'

describe Twitter, :create do
  it "creates a new twitter entry" do
    game = FactoryGirl.build(:game)
    Twitter.create(game, 'tk', 'se')
    found = Twitter.find_one
    found.game_id.should == game.id
    found.token.should == 'tk'
    found.secret.should == 'se'
    found.leaderboard_id.should be_nil
    found.message.should be_nil
  end

  it "updates the existing twitter entry" do
    game = FactoryGirl.build(:game)
    lid = Id.new
    FactoryGirl.create(:twitter, {:game_id => game.id, :message => 'the message', :leaderboard_id => lid})

    Twitter.create(game, 'newt', 'news')
    Twitter.count.should == 1
    found = Twitter.find_one
    found.game_id.should == game.id
    found.token.should == 'newt'
    found.secret.should == 'news'
    found.message.should == "the message"
    found.leaderboard_id.should == lid
  end
end