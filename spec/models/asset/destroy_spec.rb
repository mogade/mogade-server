require 'spec_helper'

describe Asset, :destroy do  
  it "deletes the asset" do
    asset = FactoryGirl.create(:asset)
    Asset.count.should == 1 #just can't help myself
    asset.destroy
    Asset.count.should == 0
  end
  
  it "deletes the file" do
    asset = FactoryGirl.create(:asset, {:file => 'abc123.zip'})
    FileStorage.should_receive(:delete_asset).with('abc123.zip')
    asset.destroy
  end
end