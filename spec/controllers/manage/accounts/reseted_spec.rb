require 'spec_helper'

describe Manage::AccountsController, :reseted do
  extend ManageHelper

  it "returns if key is missing" do   
    get :reseted
    response.should render_template('manage/accounts/reset')
    flash[:error].should == 'there was a problem loading your account, please try again (1)'
  end
  
  it "returns if key doesn't exit" do   
    id = Id.new
    Developer.should_receive(:find_by_action).with(id).and_return(nil)
    get :reseted, {:key => id.to_s}
    response.should render_template('manage/accounts/reset')
    flash[:error].should == 'there was a problem loading your account, please try again (2)'
  end
  
  it "resets the password and signs the developer in" do   
    id = Id.new
    developer = Factory.build(:developer)
    
    Developer.stub!(:find_by_action).and_return(developer)
    developer.should_receive(:reset_password).with('new_pass').and_return(true)
    get :reseted, {:key => id.to_s, :password => 'new_pass'}
    
    response.should redirect_to('http://test.host/manage/index')
    session[:dev_id].should == developer.id.to_s 
  end
  
end