require 'spec_helper'

describe Achievement, :destroy do  
  it "deletes the achievement" do
    achievement = Factory.create(:achievement)
    Achievement.count.should == 1 #just can't help myself
    achievement.destroy
    Achievement.count.should == 0
  end
end