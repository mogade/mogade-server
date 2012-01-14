require 'spec_helper'

describe Api::Gamma::UsersController, :rename do
  extend GammaApiHelper
  
  setup
  it_ensures_a_valid_context :post, :rename
  it_ensures_a_signed_request :post, :rename
  it_ensures_a_valid_player :post, :rename
  
  it "renders an error if newname are missing" do
    player = FactoryGirl.build(:player)
    post :rename, GammaApiHelper.signed_params(@game, {:username => player.username, :userkey => player.userkey})
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'missing required newname value'
  end
  
  it "renders an error if rename fails" do
    player = FactoryGirl.build(:player)
    Player.stub!(:new).with(player.username, player.userkey).and_return(player)
    player.should_receive(:rename).with(@game, 'new-name').and_return(false)
    post :rename, GammaApiHelper.signed_params(@game, {:newname => 'new-name', :username => player.username, :userkey => player.userkey})
    response.status.should == 400
    json = ActiveSupport::JSON.decode(response.body)
    json['error'].should == 'newname must be 30 or less characters'    
  end

  it "renames and returns success" do
    player = FactoryGirl.build(:player)
    Player.stub!(:new).with(player.username, player.userkey).and_return(player)
    player.should_receive(:rename).with(@game, 'new-name').and_return(true)
    post :rename, GammaApiHelper.signed_params(@game, {:newname => 'new-name', :username => player.username, :userkey => player.userkey})
    response.status.should == 200
    json = ActiveSupport::JSON.decode(response.body)
    json['success'].should == true
  end
end