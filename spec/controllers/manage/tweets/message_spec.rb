require 'spec_helper'

describe Manage::TweetsController, :message do
  extend ManageHelper

  setup
  it_ensures_a_logged_in_user :post, :message
  it_ensures_developer_owns_the_game :post, :message, Proc.new {
    twitter = FactoryGirl.build(:twitter, {:game_id => ManageHelper.game_id})
    Twitter.stub!(:find_by_id).and_return(twitter)
    {:id => twitter.id}
  }

  it "adds the message" do
    twitter = FactoryGirl.create(:twitter, {:game_id => @game.id})
    Twitter.stub!(:find_by_id).with(twitter.id).and_return(twitter)
    twitter.should_receive(:add_message).with(2, 'the-message').and_return(true)

    post :message, {:id => twitter.id, :game_id => @game.id, :scope => '2', :message => 'the-message'}
    response.should redirect_to("http://test.host/manage/tweets?id=#{@game.id}")
  end

end