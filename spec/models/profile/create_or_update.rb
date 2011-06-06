require 'spec_helper'

describe Profile, :create_or_update do
  
  it "updates an existing profile" do
    game = Factory.build(:game)
    Factory.create(:profile, {:id => game.id, :name => 'first name', :enabled => false, :description => 'description'})
    profile = Profile.create_or_update('new name', 'http://game_url_new', 'new_developer', 'http://new_developer_url', 'description_new', 1, game)
    profile.id.should == game.id
    profile.name.should == 'new name'
    profile.game_url.should == 'http://game_url_new'
    profile.developer.should == 'new_developer'
    profile.developer_url.should == 'http://new_developer_url'
    profile.description.should == 'description_new'
    profile.enabled.should be_true
  end
  
  it "create a new profile" do
    game = Factory.build(:game)
    Factory.create(:profile, {:id => game.id, :name => 'first name', :enabled => false, :description => 'description'})
    profile = Profile.create_or_update('new name', 'http://game_url_new', 'new_developer', 'http://new_developer_url', 'description_new', 1, game)
    profile.name.should == 'new name'
    profile.game_url.should == 'http://game_url_new'
    profile.developer.should == 'new_developer'
    profile.developer_url.should == 'http://new_developer_url'
    profile.description.should == 'description_new'
    profile.enabled.should be_true
  end
  
  it "adds http infront of urls if needed" do
    game = Factory.build(:game)
    Factory.create(:profile, {:id => game.id, :name => 'first name', :enabled => false, :description => 'description'})
    profile = Profile.create_or_update('new name', 'incomplete_url', 'new_developer', 'incomplete_url2', 'description_new', 1, game)
    profile.game_url.should == 'http://incomplete_url'
    profile.developer_url.should == 'http://incomplete_url2'
  end
  
end