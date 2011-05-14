class Manage::SessionsController < Manage::ManageController
  
  def new
  end
  
  def create
  end

  def logout
    session.delete(:dev_id)
    redirect_to '/'
  end
end