require 'spec_helper'

describe Manage::SessionsController, :logout do
  extend ManageHelper

  it "logs the user out" do   
    session[:dev_id] = 32
    get :logout
    response.should redirect_to('/')
    session.has_key?(:dev_id).should be_false
  end

end