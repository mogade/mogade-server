require 'bcrypt'
class Signup 
  include ActiveModel::Validations
  attr_accessor :name, :email, :password, :human
  
  validates_length_of :name, :minimum => 2, :maximum => 40, :allow_blank => false, :message => 'please enter a name'
  validates_format_of :email, :with => /^\S+@\S+\.\S+$/, :allow_blank => false, :message => 'please enter a valid email'
  validates_format_of :password, :with => /.*[^a-zA-Z].*[^a-zA-Z]/, :allow_blank => false, :message => 'please enter a valid password'  
  validates_confirmation_of :password, :message => 'passwords do not match'
  validates_format_of :human, :with => /^luigi$/i, :allow_blank => false, :message => '01100110 01100001 01101001 01101100'
  
  def initialize(params = nil)
    return if params.nil?
    @name = params[:name]
    @email = params[:email]
    @password = params[:password]
    @human = params[:human]
  end
  
  def to_user
    return nil unless valid?
    User.new({
      :name => name, 
      :email => email, 
      :password => BCrypt::Password.create(password),
      :status => UserStatus::Pending,
      :action => IdGenerator.new
    })
  end
end