require 'spec_helper'

describe Manage::TweetsController, :callback do
  extend ManageHelper

  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy

  it "saves nil token" do
    Twitter.should_receive(:disable).with(@game)
    delete :destroy, :id => @game.id
    response.should render_template('manage/tweets/index')
  end
end