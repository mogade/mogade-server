require 'spec_helper'

describe Api::StatsController, :create do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_version :post, :create
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  
  it "renders an error if userkey is missing" do
    post :create, ApiHelper.signed_params(@game)
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'missing required userkey value'
  end
  
  it "hits the stat" do
    Stat.should_receive(:hit).with(@game, 'gpath')
    post :create, ApiHelper.signed_params(@game, {:userkey => 'gpath'})
  end
  
  it "returns nothing" do
    post :create, ApiHelper.signed_params(@game, {:userkey => 'gpath'})
    response.status.should == 200
    response.body.blank?.should be_true
  end
  
end