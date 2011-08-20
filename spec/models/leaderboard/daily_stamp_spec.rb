require 'spec_helper'

describe Leaderboard, :daily_stamp do
  
  it "returns the time adjusted for no offset" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 4, 0, 3).getlocal('+05:00'))
    FactoryGirl.build(:leaderboard, {:offset => 0}).daily_stamp.should == Time.utc(2010, 8, 10)
  end
  
  it "returns the time adjusted for a negative offset which has rolled over to today" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 4, 0, 3).getlocal('+06:00'))
    FactoryGirl.build(:leaderboard, {:offset => -3}).daily_stamp.should == Time.utc(2010, 8, 10, 3)
  end
  
  it "returns the time adjusted for a negative offset which hasn't rolled over to today" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 4, 0, 2).getlocal('+07:00'))
    FactoryGirl.build(:leaderboard, {:offset => -5}).daily_stamp.should == Time.utc(2010, 8, 9, 5)
  end
  
  it "returns the time adjusted for a postive offset which hasn't rolled over to today" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 20, 0, 1).getlocal('+06:00'))
    FactoryGirl.build(:leaderboard, {:offset => 3}).daily_stamp.should == Time.utc(2010, 8, 9, 21)
  end
  
  it "returns the time adjusted for a postive offset which has rolled over to today" do
    Time.stub!(:now).and_return(Time.utc(2010, 8, 10, 20, 0, 3).getlocal('+02:00'))
    FactoryGirl.build(:leaderboard, {:offset => 5}).daily_stamp.should == Time.utc(2010, 8, 9, 19)
  end

end