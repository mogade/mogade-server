require 'spec_helper'

describe Manage::StatsController, :data do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :data
  it_ensures_developer_owns_the_game :get, :data
  
  it "returns the data" do
    data = {:stats => true}
    Stat.should_receive(:load_data).with(@game, Time.utc(2010, 1, 1), Time.utc(2010, 1, 15)).and_return(data)
    get :data, {:id => @game.id, :from => 1262304000, :to => 1263513600}
    json = ActiveSupport::JSON.decode(response.body)
    json['stats'].should be_true
  end
  
  it "returns the custom data" do
    data = {:stats => true}
    Stat.should_receive(:load_custom_data).with(@game, Time.utc(2010, 1, 1), Time.utc(2010, 1, 15)).and_return(data)
    get :data, {:id => @game.id, :from => 1262304000, :to => 1263513600, :custom => 'true'}
    json = ActiveSupport::JSON.decode(response.body)
    json['stats'].should be_true
  end
  
  it "returns the data for a year" do
    data = {:stats => true}
    Stat.should_receive(:load_data_for_year).with(@game, '13').and_return(data)
    get :data, {:id => @game.id, :year => '13'}
    response.headers['Content-Disposition'].should == 'attachment; filename="mogade.stats.power level?.2013.json"'
    response.body.should == "{:stats=>true}"
  end

end