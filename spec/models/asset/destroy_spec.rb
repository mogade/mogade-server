require 'spec_helper'

describe Asset, :destroy do  
  it "deletes the leaderboard" do
    asset = FactoryGirl.create(:asset)
    Asset.count.should == 1 #just can't help myself
    asset.destroy
    Asset.count.should == 0
  end
end