class Manage::SessionsController < Manage::ManageController
  
  def new
  end
  
  def create
    developer = Developer.find_by_credential(params[:email], params[:password])
    if developer.nil?
      message = 'invalid email or password, please try again' 
    elsif developer.status != DeveloperStatus::Enabled
      message = 'this account is not activated'
    else
      return signin(developer)
    end
    set_error (message)
    render :action => :new
  end

  def logout
    session.delete(:dev_id)
    redirect_to '/'
  end
end