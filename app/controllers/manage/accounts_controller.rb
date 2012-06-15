class Manage::AccountsController < Manage::ManageController
  skip_before_filter :ensure_not_https
  before_filter :ensure_https

  def new
    @signup = Signup.new
  end

  def register
    redirect_to :action => :new
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

  def forgot
    render :layout => 'manage_single'
  end

  def send_reset
    developer = Developer.set_new_action(params[:email])
    if developer.nil?
      set_error('the email could not be found')
      render :action => :forgot
      return
    end

    url = url_for :action => 'reset', :key => developer.action, :only_path => false
    Notifier.reset_password(developer, url)
    render :layout => 'manage_single'
  end

  def reset
    @key = params[:key]
    render :layout => 'manage_single'
  end

  def reseted
    key = Id.from_string(params[:key])
    @key = key.to_s unless key.nil?
    if key.nil? || Id.expired?(key, 1)
      set_error('there was a problem loading your account, please try again (1)')
      render :reset and return
    end
    developer = Developer.find_by_action(key)
    if developer.nil?
      set_error('there was a problem loading your account, please try again (2)')
      render :reset and return
    end
    if developer.reset_password(params[:password])
      return signin(developer)
    end
    render :reset
  end
end