require 'spec_helper'

describe Api::Gamma::ErrorsController, :create do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  
  it "renders an error if subject is missing" do
    post :create, GammaApiHelper.signed_params(@game)
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'missing required subject value'
  end
  
  it "hits the stat" do
    GameError.should_receive(:create).with(@game, 'oh hoh', 'nooo')
    post :create, GammaApiHelper.signed_params(@game, {:subject => 'oh hoh', :details => 'nooo'})
  end
  
  it "returns nothing" do
    post :create, GammaApiHelper.signed_params(@game, {:subject => 'khan!!!'})
    response.status.should == 200
    response.body.blank?.should be_true
  end
end