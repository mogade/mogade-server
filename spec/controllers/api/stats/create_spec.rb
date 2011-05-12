require 'spec_helper'

describe Api::StatsController, :create do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_version :post, :create
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  
  it "renders an error if unique is missing" do
    post :create, ApiHelper.signed_params(@game)
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'missing required unique value'
  end
  
end