require 'spec_helper'

describe Achievement, :destroy do  
  it "deletes the achievement" do
    achievement = FactoryGirl.create(:achievement)
    Achievement.count.should == 1 #just can't help myself
    achievement.destroy
    Achievement.count.should == 0
  end
  
  it "deletes the any earned achievements" do
    achievement = FactoryGirl.create(:achievement, {:id => Id.new})
    EarnedAchievement.create(achievement, FactoryGirl.build(:player))
    EarnedAchievement.create(achievement, FactoryGirl.build(:player))
    EarnedAchievement.create(FactoryGirl.create(:achievement, {:id => Id.new}), FactoryGirl.build(:player))
    EarnedAchievement.create(FactoryGirl.create(:achievement, {:id => Id.new}), FactoryGirl.build(:player))
    EarnedAchievement.create(achievement, FactoryGirl.build(:player))
    
    achievement.destroy
    EarnedAchievement.count.should == 2
    EarnedAchievement.count({:achievement_id => achievement.id}).should == 0
  end
end