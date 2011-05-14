require 'spec_helper'

describe Manage::SignupsController, :activate do
  extend ManageHelper

  it "returns if key is missing" do   
    get :activate
    response.should render_template('manage/signups/activate')
  end
  
  it "returns if key is invalid" do   
    get :activate, {:key => 'invalid' }
    response.should render_template('manage/signups/activate')
  end
  
  it "returns if key is expires" do   
    Id.stub!(:expired?).and_return(true)
    get :activate, {:key => Id.new }
    response.should render_template('manage/signups/activate')
  end

  it "returns if developer isn't found" do   
    Id.stub!(:expired?).and_return(false)
    get :activate, {:key => Id.new}
    response.should render_template('manage/signups/activate')
  end
  
  it "activate the developer and signs her it" do
    action = Id.new
    developer = Factory.build(:developer)
    
    Developer.should_receive(:find_by_action).with(action).and_return(developer)
    Id.stub!(:expired?).and_return(false)
    get :activate, {:key => action.to_s }
    
    response.should redirect_to('http://test.host/manage/index')
    session[:dev_id].should == developer.id.to_s
  end
end