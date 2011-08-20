require 'spec_helper'

describe Asset, :update do
  it "updates the asset" do
    asset = FactoryGirl.create(:asset, {:name => 'old name', :type => 5, :meta => 'my meta'})
    asset.update('new name', 5, 'new meta')
    asset.name.should == 'new name'
    asset.type.should == 5
    asset.meta.should == 'new meta'
    Asset.count.should == 1
    Asset.count({
      :_id => asset.id, 
      :name => 'new name', 
      :type => 5,
      :meta => 'new meta'}).should == 1
  end
end