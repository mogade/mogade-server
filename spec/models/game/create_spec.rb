require 'spec_helper'

describe Game, :create do
  it "creates a new game" do
    Id.should_receive(:secret).and_return('sauce')
    game = Game.create('ham zapper')
    game.name.should == 'ham zapper'
    game.secret.should == 'sauce'
  end
end