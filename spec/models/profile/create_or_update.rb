require 'spec_helper'

describe Profile, :create_or_update do
  
  it "updates an existing profile" do
    game = FactoryGirl.build(:game)
    leaderboard_id = Id.new
    FactoryGirl.create(:profile, {:id => game.id, :name => 'first name', :enabled => false, :description => 'description', :leaderboard_id => Id.new})
    
    profile = Profile.create_or_update('new name',  'description_new', 1, leaderboard_id, game)
    profile.id.should == game.id
    profile.name.should == 'new name'
    profile.description.should == 'description_new'
    profile.leaderboard_id.should == leaderboard_id
    profile.enabled.should be_true
  end
  
  it "create a new profile" do
    game = FactoryGirl.build(:game)
    leaderboard_id = Id.new
    FactoryGirl.create(:profile, {:id => game.id, :name => 'first name', :enabled => false, :description => 'description'})
    profile = Profile.create_or_update('new name', 'description_new', 1, leaderboard_id, game)
    profile.name.should == 'new name'
    profile.description.should == 'description_new'
    profile.leaderboard_id.should == leaderboard_id
    profile.enabled.should be_true
  end
  
  it "adds http infront of urls if needed" do
    game = FactoryGirl.build(:game)
    FactoryGirl.create(:profile, {:id => game.id, :name => 'first name', :enabled => false, :description => 'description'})
    profile = Profile.create_or_update('new name', 'incomplete_url', 'new_developer', 'incomplete_url2', 'description_new', 1, nil, game)
    profile.game_url.should == 'http://incomplete_url'
    profile.developer_url.should == 'http://incomplete_url2'
  end
  
end