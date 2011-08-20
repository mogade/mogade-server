require 'spec_helper'

describe Achievement, :update do
  it "updates the achievement" do
    achievement = FactoryGirl.build(:achievement, {:name => 'old name', :description => 'old description', :points => 86})
    achievement.update('new name', 'new description', 56)
    achievement.name.should == 'new name'
    achievement.description.should == 'new description'
    achievement.points.should == 56
    Achievement.count({:_id => achievement.id, :name => 'new name', :description => 'new description', :points => 56}).should == 1
  end
end