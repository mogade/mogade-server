require 'spec_helper'

describe Manage::StatsController, :update do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :update
  it_ensures_developer_owns_the_game :post, :update

  it "updates the stat names " do
    @game.should_receive(:set_stat_names).with(['name-1', 'name-2', 'name-3', '4', '5'])
    post :update, {:id => @game.id, :stat_0 => 'name-1', :stat_1 => 'name-2', :stat_2 => 'name-3'}
    response.should redirect_to('http://test.host/manage/manage/stats/custom/' + @game.id.to_s)
  end
  
end