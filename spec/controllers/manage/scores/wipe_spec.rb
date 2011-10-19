require 'spec_helper'

describe Manage::ScoresController, :wipe do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :wipe
  it_ensures_developer_owns_the_game :get, :wipe

  it "wipe the scores" do
    ScoreDeleter.should_receive(:wipe).with(@game).and_return(454)
    get :wipe, {:id => @game.id}
    response.should redirect_to('/manage/scores?id=' + @game.id.to_s)
  end

end