require 'spec_helper'

describe HomeController, :profile do
  it "returns a 404 if the id is missing" do
    get :profile
    response.should render_template('home/404_profile')
  end
  
  it "returns a 404 if the profile isn't valid" do
    get :profile, {:id => Id.new}
    response.should render_template('home/404_profile')
  end
  
  it "returns a 404 if the profile is disabled" do
    factory = Factory.create(:profile, {:enabled => false})
    get :profile, {:id => factory.id.to_s}
    response.should render_template('home/404_profile')
  end
end