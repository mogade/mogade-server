class Manage::SignupsController < Manage::ManageController
  
  def new
    @signup = Signup.new
  end
  
  def create
    @signup = Signup.new(params)
    begin
      developer = @signup.to_developer
      if !developer.nil? && developer.save!
        url = url_for :action => 'activate', :key => developer.action, :only_path => false
        Notifier.welcome(developer, url) 
        return
      end
    rescue Mongo::OperationFailure
      @signup.errors.add('email', 'email is already taken') if $!.duplicate?
    end
    render :action => 'new'
  end
  
  def activate
    id = Id.from_string(params[:key])
    return if id.nil? || Id.expired?(id, 2) 
    
    developer = Developer.find_by_action(id)
    return if developer.nil?
    return signin(developer.activate!)
  end
end