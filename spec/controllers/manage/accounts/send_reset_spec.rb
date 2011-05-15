require 'spec_helper'

describe Manage::AccountsController, :send_reset do
  extend ManageHelper

  it "displays an error if the developer isn't found" do
    get :send_reset
    response.should render_template('manage/accounts/forgot')    
  end
  
  it "does a password reset" do
    developer = Factory.build(:developer, {:action => 'the_key'})
    Developer.should_receive(:set_new_action).with('gohan@dbz.org').and_return(developer)
    Notifier.should_receive(:reset_password).with(developer, 'http://test.host/manage/accounts/reset/the_key')
    
    post :send_reset, {:email => 'gohan@dbz.org'}
    response.should render_template('manage/accounts/send_reset')
  end
end