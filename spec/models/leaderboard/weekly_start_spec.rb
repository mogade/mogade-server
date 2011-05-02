require 'spec_helper'

describe Leaderboard, :weekly_start do
  
  it "returns the time adjusted for no offset" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 11, 10, 20, 3).getlocal('+05:00'))
    Factory.build(:leaderboard, {:offset => 0}).weekly_start.should == Time.utc(2010, 8, 9)
  end

  it "returns the time adjusted for a negative offset which has rolled over to this week" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 11, 10, 20, 3).getlocal('+06:00'))
    Factory.build(:leaderboard, {:offset => -7}).weekly_start.should == Time.utc(2010, 8, 9, 7)
  end
  
  it "returns the time adjusted for a negative offset which hasn't rolled over to this week" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 9, 1, 21, 22).getlocal('+02:00'))
    Factory.build(:leaderboard, {:offset => -4}).weekly_start.should == Time.utc(2010, 8, 2, 4)
  end
  
  it "returns the time adjusted for a postive offset which hasn't rolled over to this week" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 20, 0, 1).getlocal('+06:00'))
    Factory.build(:leaderboard, {:offset => 2}).weekly_start.should == Time.utc(2010, 8, 8, 22)
  end
  
  it "returns the time adjusted for a postive offset which has rolled over to this week" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 20, 0, 3).getlocal('+02:00'))
    Factory.build(:leaderboard, {:offset => 5}).weekly_start.should == Time.utc(2010, 8, 8, 19)
  end

end