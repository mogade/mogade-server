require 'spec_helper'

describe FacebookController, :index do
  it "returns a 404 if the profile isn't valid" do
    get :index, {:id => Id.new}
    response.should render_template('facebook/404_profile')
  end
  
  it "returns a 404 if the profile is disabled" do
    factory = Factory.create(:profile, {:enabled => false})
    get :index, {:id => factory.id.to_s}
    response.should render_template('facebook/404_profile')
  end
end