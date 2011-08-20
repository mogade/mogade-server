require 'spec_helper'

describe EarnedAchievement, :create do
  it "creates new earned achievement" do
    now = Time.now.utc
    Time.stub!(:now).and_return(now)
    player = FactoryGirl.build(:player)
    achievement = FactoryGirl.build(:achievement)
    earned = EarnedAchievement.create(achievement, player)
    earned.achievement_id.should == achievement.id
    earned.unique.should == player.unique
    earned.username.should == player.username
    earned.dated.should == now
  end
  
  it "saves the new earned achievement" do
    now = Time.now.utc
    Time.stub!(:now).and_return(now)
    player = FactoryGirl.build(:player)
    achievement = FactoryGirl.build(:achievement)
    earned = EarnedAchievement.create(achievement, player)
    EarnedAchievement.count({:achievement_id => achievement.id, :unique => player.unique, :dated => now, :username => player.username}).should == 1
  end
  
  it "returns nil when already earned" do    
    player = FactoryGirl.build(:player)
    achievement = FactoryGirl.build(:achievement)
    EarnedAchievement.create(achievement, player)
    EarnedAchievement.create(achievement, player).should be_nil
  end
end