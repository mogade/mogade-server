require 'spec_helper'

describe Api::Gamma::AssetsController, :index do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :get, :index
  
  it "gets an empty array if there are no assets" do
    get :index, GammaApiHelper.params(@game)
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json.length.should == 0
  end

  it "gets the assets" do
    Asset.should_receive(:find_for_game).with(@game, true).and_return([{:name => 1, :dated => Time.now}, {:name => 2, :dated => Time.now - 1000}, {:name => 3, :dated => Time.now + 1000}])
    get :index, GammaApiHelper.params(@game)
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json[0]['name'].should == 3
    json[1]['name'].should == 1
    json[2]['name'].should == 2
  end
  
  it "returns a nil file" do
    Asset.should_receive(:find_for_game).with(@game, true).and_return([{:file => nil}])
    get :index, GammaApiHelper.params(@game)
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json[0]['file'].should be_nil
  end
  
  it "returns a fixed file" do
    Asset.should_receive(:find_for_game).with(@game, true).and_return([{:file => '9001.zip'}])
    get :index, GammaApiHelper.params(@game)
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json[0]['file'].should == 'http://s3.amazonaws.com/invalid/assets/9001.zip'
  end  
  
end