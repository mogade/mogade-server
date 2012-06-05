require 'spec_helper'

describe Manage::TweetsController, :update do
  extend ManageHelper

  setup
  it_ensures_a_logged_in_user :put, :update
  it_ensures_developer_owns_the_game :put, :update, Proc.new {
    twitter = FactoryGirl.build(:twitter, {:game_id => ManageHelper.game_id})
    Twitter.stub!(:find_by_id).and_return(twitter)
    {:id => twitter.id}
  }


  it "verifies that the twitter belongs to the game" do
    twitter = FactoryGirl.create(:twitter, {:game_id => Id.new})
    Twitter.stub!(:find_by_id).with(twitter.id).and_return(twitter)

    put :update, {:id => twitter.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end

  it "updates the twitter settings" do
    lid = Id.new
    twitter = FactoryGirl.create(:twitter, {:game_id => @game.id})
    Twitter.stub!(:find_by_id).and_return(twitter)
    twitter.should_receive(:update).with('new message', lid)

    put :update, {:id => twitter.id, :game_id => @game.id, :message => 'new message', :leaderboard_id => lid.to_s}
    response.should redirect_to("http://test.host/manage/tweets?id=#{@game.id}")
  end
end