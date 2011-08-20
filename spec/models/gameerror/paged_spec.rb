require 'spec_helper'

describe GameError, :paged do
  it "returns an empty array if no errors exist" do
    GameError.paged(FactoryGirl.build(:game), 1).to_a.should == []
  end
  
  it "returns an page of errorst" do
    game = FactoryGirl.build(:game)
    25.times do |i|
      FactoryGirl.create(:game_error, {:game_id => game.id, :hash => "hash-#{i}", :subject => "s-#{i}", :updated => Time.now - i})
    end
    errors = GameError.paged(game, 3).to_a
    errors.length.should == 5
    errors[0].subject = 's-20'
    errors[4].subject = 's-24'
  end
  
  it "only gets errors for the specified game" do
    game = FactoryGirl.build(:game)
    FactoryGirl.create(:game_error, {:game_id => game.id, :hash => "h1", :subject => "s1"})
    FactoryGirl.create(:game_error, {:game_id => game.id, :hash => "h2", :subject => "s2"})
    FactoryGirl.create(:game_error, {:game_id => Id.new, :hash => "h3", :subject => "s3"})
    errors = GameError.paged(game, 1).to_a
    errors.length.should == 2
    errors.collect{|e| e.game_id == game.id}.length.should == 2
  end
end