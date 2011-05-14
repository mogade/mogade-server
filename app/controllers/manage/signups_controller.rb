class Manage::SignupsController < Manage::ManageController
  def index
     
  end
  def new
    @signup = Signup.new
  end
end