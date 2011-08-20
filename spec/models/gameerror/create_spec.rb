require 'spec_helper'

describe GameError, :create do
  before(:each) do
    @now = Time.now.utc
    Time.stub!(:now).and_return(@now)
  end
  it "logs a new error" do
    game = FactoryGirl.build(:game)
    Digest::SHA1.stub!(:hexdigest).with("#{game.id.to_s}the subjectthe details").and_return('the hash')
    GameError.create(game, 'the subject', 'the details')
    GameError.count({:game_id => game.id, :subject => 'the subject', :details => 'the details', :hash => 'the hash', :count => 1, :dated => @now, :updated => @now}).should == 1
  end
  
  it "limits the subject to 150 charaters" do
    game = FactoryGirl.build(:game)
    Digest::SHA1.should_receive(:hexdigest).with("#{game.id.to_s}#{'s' * 150}")
    GameError.create(game, 's' * 200, nil)
    GameError.count({:subject => 's' * 150}).should == 1
  end
  
  it "limits the details to 2000 charaters" do
    game = FactoryGirl.build(:game)
    Digest::SHA1.should_receive(:hexdigest).with("#{game.id.to_s}s#{'d' * 2000}")
    GameError.create(game, 's', 'd' * 2005)
    GameError.count({:details => 'd' * 2000}).should == 1
  end
  
  it "increments the count and updates the timestamp of a duplicate error" do
    created = Time.now - 100000
    game = FactoryGirl.build(:game)
    FactoryGirl.create(:game_error, {:game_id => game.id, :dated => created, :updated => created, :count => 5, :hash => 'the hash'})
    Digest::SHA1.stub!(:hexdigest).and_return('the hash')
    
    GameError.create(game, 's', 'd')
    GameError.count.should == 1
    GameError.count({:count => 6, :updated => @now, :dated => created}).should == 1
  end
end