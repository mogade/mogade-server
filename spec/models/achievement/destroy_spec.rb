require 'spec_helper'

describe Achievement, :destroy do  
  it "deletes the achievement" do
    achievement = Factory.create(:achievement)
    Achievement.count.should == 1 #just can't help myself
    achievement.destroy
    Achievement.count.should == 0
  end
  
  it "deletes the any earned achievements" do
    achievement = Factory.create(:achievement, {:id => Id.new})
    EarnedAchievement.create(achievement, Factory.build(:player))
    EarnedAchievement.create(achievement, Factory.build(:player))
    EarnedAchievement.create(Factory.create(:achievement, {:id => Id.new}), Factory.build(:player))
    EarnedAchievement.create(Factory.create(:achievement, {:id => Id.new}), Factory.build(:player))
    EarnedAchievement.create(achievement, Factory.build(:player))
    
    achievement.destroy
    EarnedAchievement.count.should == 2
    EarnedAchievement.count({:achievement_id => achievement.id}).should == 0
  end
end