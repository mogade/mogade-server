class Manage::SessionsController < Manage::ManageController
  skip_before_filter :ensure_not_https
  before_filter :ensure_https, :except => [:logout]
    
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