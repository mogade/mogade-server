require 'spec_helper'

describe Manage::SessionsController, :create do
  extend ManageHelper

  it "renders an error if the credentials aren't valid" do
    get :create
    response.should render_template('manage/sessions/new')
    flash[:error].should == "invalid email or password, please try again"
  end
  
  it "renders an error if the developer isn't enabled" do
    Developer.stub!(:find_by_credential).and_return(Factory.build(:developer, {:status => DeveloperStatus::Pending}))
    get :create
    response.should render_template('manage/sessions/new')
    flash[:error].should == "this account is not activated"
  end
  
  it "signs the developer in" do
    developer = Factory.build(:developer)
    Developer.should_receive(:find_by_credential).with('duncan@sword.org', 'ghola').and_return(developer)
    
    get :create, {:email => 'duncan@sword.org', :password => 'ghola'}
    response.should redirect_to('http://test.host/manage/games/')
    session[:dev_id].should == developer.id.to_s
  end

end