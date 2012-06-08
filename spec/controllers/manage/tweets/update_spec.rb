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
    twitter.should_receive(:update) do |params|
      params[:leaderboard_id].should == lid.to_s
      params[:daily].should == {'interval' => "20"}
      params[:weekly].should == {'interval' => "25"}
      params[:overall].should == {'interval' => "30"}
    end
    put :update, {:id => twitter.id, :game_id => @game.id, :leaderboard_id => lid.to_s, :daily => {:interval => "20"}, :weekly => {:interval => "25"}, :overall => {:interval => "30"}}
    response.should redirect_to("http://test.host/manage/tweets?id=#{@game.id}")
  end
end