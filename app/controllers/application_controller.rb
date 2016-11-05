class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  helper :all
  #before_action :load_filter#, :except => ['session/create']

  
  def load_filter
    if params[:key].present?
      authenticate_user_from_token!
    else
      authenticate_user!
    end
  end
  
  
  def authenticate_admin
    unless (user_signed_in? and current_user.admin?)
     redirect_to root_path
    end
  end

  def facebook_logout
    split_token = session[:fb_token].split("|")
    fb_session_key = split_token[0]
    session[:fb_token] = nil
    redirect_to "https://www.facebook.com/logout.php?access_token=#{fb_session_key}&session_key=a6ef2588ae291223de806f4fb0142214&confirm=1&next=#{destroy_user_session_url}"
  end

  def get_notifications
  	if current_user.present?
      # @notifications = []
      @date = current_user.last_sign_in_at
  		@all_notifications = Audited::Adapters::ActiveRecord::Audit.where('(auditable_type = ? or auditable_type = ? or auditable_type = ?) and created_at > ?', "Note", "Cherish", "Member", @date)
      @notifications = @all_notifications.map{|n| n.audited_changes rescue nil if (n.audited_changes["user_id"].to_i == current_user.id and n.audited_changes["user_id"].to_i != n.audited_changes["sender_id"].to_i) }.compact 
  	end
  end
  
  def after_sign_in_path_for(resource_or_scope)
    if current_user.present? and current_user.admin
      url = doctors_path
    elsif current_user.present? and current_user.type == 'Doctor'
      url = profile_doctor_path(:id => current_user.id)
    else
      url = root_path
    end
    url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:type, :username, :email, :password, :password_confirmation, :remember_me, :licence, :mobile_no, :city, :country, :surname, :gender, :terms_and_condition, :specialize) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

 
  private  
  # For this example, we are simply using token authentication
  # via parameters. However, anyone could use Rails's token
  # authentication features to get the token from a header.
  def authenticate_user_from_token!
    key = params[:key].presence
    user = key && User.find_by_key(key)
    if user.nil?
      render :status=>401, :json=>{:status=>"Failure", :status_code => 401, :message=>"Invalid Key."}
      return
    end
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:authentication_token]) && user.authentication_token.present?
      user.update_column(:badge_count, 0)
      sign_in user, store: true
    else
      render :status=>401, :json=>{:status=>"Failure", :status_code => 401, :message=>"Invalid Authentication token."}
      return
    end
  end
  
end

