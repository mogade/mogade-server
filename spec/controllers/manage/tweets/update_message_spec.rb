require 'spec_helper'

describe Manage::TweetsController, :update_message do
  extend ManageHelper

  setup
  it_ensures_a_logged_in_user :put, :update_message
  it_ensures_developer_owns_the_game :put, :update_message, Proc.new {
    twitter = FactoryGirl.build(:twitter, {:game_id => ManageHelper.game_id})
    Twitter.stub!(:find_by_id).and_return(twitter)
    {:id => twitter.id}
  }

  it "updates the message" do
    twitter = FactoryGirl.create(:twitter, {:game_id => @game.id})
    Twitter.stub!(:find_by_id).with(twitter.id).and_return(twitter)
    twitter.should_receive(:update_message).with(1, 3, 'new message').and_return(true)

    put :update_message, {:id => twitter.id, :game_id => @game.id, :scope => '1', :index => '3', :message => 'new message'}
    response.should redirect_to("http://test.host/manage/tweets?id=#{@game.id}")
  end

end