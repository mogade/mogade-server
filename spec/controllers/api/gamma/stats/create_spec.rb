require 'spec_helper'

describe Api::Gamma::StatsController, :create do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  
  it "hits the stat with a user key" do
    Stat.should_receive(:hit).with(@game, 'gpath')
    post :create, GammaApiHelper.signed_params(@game, {:userkey => 'gpath'})
  end

  it "hits the stat with a custom index" do
    Stat.should_receive(:hit_custom).with(@game, 2)
    post :create, GammaApiHelper.signed_params(@game, {:custom => '2'})
  end
  
  it "returns nothing" do
    post :create, GammaApiHelper.signed_params(@game, {:userkey => 'gpath'})
    response.status.should == 200
    response.body.blank?.should be_true
  end
  
end