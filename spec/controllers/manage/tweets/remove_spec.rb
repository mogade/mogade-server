require 'spec_helper'

describe Manage::TweetsController, :remove do
  extend ManageHelper

  setup
  it_ensures_a_logged_in_user :delete, :remove
  it_ensures_developer_owns_the_game :delete, :remove, Proc.new {
    twitter = FactoryGirl.build(:twitter, {:game_id => ManageHelper.game_id})
    Twitter.stub!(:find_by_id).and_return(twitter)
    {:id => twitter.id}
  }

  it "deletes the message" do
    twitter = FactoryGirl.create(:twitter, {:game_id => @game.id})
    Twitter.stub!(:find_by_id).with(twitter.id).and_return(twitter)
    twitter.should_receive(:remove_message).with(2, 5).and_return(true)

    delete :remove, {:id => twitter.id, :game_id => @game.id, :scope => '2', :index => '5'}
    response.should redirect_to("http://test.host/manage/tweets?id=#{@game.id}")
  end

end