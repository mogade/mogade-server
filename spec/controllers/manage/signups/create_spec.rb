require 'spec_helper'

describe Manage::SignupsController, :create do
  extend ManageHelper
  
  it "renders the registartion page if the signup is invalid" do
    post :create, {}
    response.should render_template('manage/signups/new')
  end
  
  it "renders the registartion page if the email is already in use" do
    Factory.create(:developer, {:email => 'my@email.com'})
    post :create, {:email => 'my@email.com', :name => 'my name', :password => 'pass1234', :confirm_password => 'pass1234', :human => 'luigi'}
    response.should render_template('manage/signups/new')
    assigns[:signup].errors[:email][0].should == 'email is already taken'
  end
  
  it "registers the player" do
    Id.stub!(:new).and_return('the_id')
    Notifier.should_receive(:welcome).with(anything(), 'http://test.host/manage/signups/activate/the_id')
    post :create, {:email => 'my@email.com', :name => 'my name', :password => 'pass1234', :confirm_password => 'pass1234', :human => 'luigi'}
    response.should render_template('manage/signups/create')
    
    Developer.count({:email => 'my@email.com', :name => 'my name'}).should == 1
  end
end