class TokensController  < ApplicationController
  skip_before_action :load_filter
  skip_before_action :authenticate_user!
  include ActionController::MimeResponds
  include ActionController::Cookies

  respond_to :json
  
  def create
    secret_key = params[:secret_key]
    key = params[:key]
    if request.format != :json
      render :status=>406, :json=>{:status=>"Failure",:message=>"The request must be json"}
      return
    end
    
    if secret_key.nil? or key.nil?
       render :status=>400,
              :json=>{:status=>"Failure",:message=>"The request must contain the secret key and key."}
       return
    end
 
    @user = User.find_by_key(key)
    
    if params[:device_token].present?
      device = Device.where(:token => params[:device_token]).first
      if device.present?
        device.update_column(:user_id, @user.id)
      else
        Device.create(:user_id => @user.id, :token => params[:device_token], :device_type => params[:device_type])
      end
    else
      render :status=>401, :json=>{:status=>"Failure",:message=>"device token cant be blank."}
      return
    end

    if @user.nil?
      logger.info("User failed signin, user cannot be found.")
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Key."}
      return
    end
 
    # # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token
    if @user.status?  
      if @user and (@user.get_secret_key.present? and params[:secret_key].present? and @user.get_secret_key.bytesize == params[:secret_key].bytesize ) and @user.authentication_token.present?
        render :status=>200, :json=>{:status=>"Success",
               :user => @user.user_response_data,
               :via => 'signin',
               :message => 'Signin Successfully'
               }
        sign_in @user, store: true
      else
      	render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Scecret Key."}
        return
      end
    else
      render :status=>401, :json=>{:status=>"Failure",:message=>"Your Account is Not Approved - Please Contact Admin."}
      return
    end    

    # if not @user.valid_password?(password)
    #   logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
    #   render :status=>401, :json=>{:message=>"Invalid email or password."}
    # else
    #   render :status=>200, :json=>{:token=>@user.authentication_token}
    # end    
  end
 
  def destroy_token
    key = params[:key].presence
    user = key && User.find_by_key(key)
 		if user.nil?
 			render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Key."}
      return
 		end
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user #&& Devise.secure_compare(user.authentication_token, params[:authentication_token]) && user.authentication_token.present? ############## Commented for mulyiple devices login and logout ############
      user.update_column(:authentication_token, nil)
      render :status=>200, :json=>{:status=>"Success",:message=>"Authentication token set to nil"}
    else
    	render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Authentication token."}
      return
    end
  end

  def check_token
  	key = params[:key].presence
    user = key && User.find_by_key(key)
 		if user.nil?
 			render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Key."}
      return
 		end
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:authentication_token]) && user.authentication_token.present?
      render :status=>200, :json=>{:status=>"Success"}
    else
    	render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Authentication token."}
      return
    end
  end

  def get_key
    email = params[:email]
#    username = params[:username]
    password = params[:password]
    if request.format != :json
      render :status=>406, :json=>{:status=>"Failure",:message=>"The request must be json"}
      return
    end
 
#    if username.nil? or password.nil?
#      render :status=>400,:json=>{:status=>"Failure",:message=>"The request must contain the user name and password."}
#      return
#    end
    
    if email.nil? or password.nil?
      render :status=>400,:json=>{:status=>"Failure",:message=>"The request must contain the email and password."}
      return
    end
 
#    @user=User.find_by_username(username)
    @user=User.find_by_email(email.downcase)
 
#     if @user.nil?
#       logger.info("User #{username} failed signin, user cannot be found.")
#       render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid email"}
#       return
#     end
 
    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid email"}
      return
    end
 
    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token
#    if not @user.valid_password?(password)
#      logger.info("User #{username} failed signin, password \"#{password}\" is invalid")
#      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid password."}
#    else
#      render :status=>200, :json=>{:status=>"Success",:secret_key=>@user.secret_key,:key=>@user.key}
#    end
#  end

    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid password."}
    else
      @user.save
      render :status=>200, :json=>{:status=>"Success",:secret_key=>@user.secret_key,:key=>@user.key}
    end
  end
  
  
  
  def user_sign_up
    if params[:username].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Name is required"}
       return
    end
    # if params[:surname].blank?
    #   render :status => 400,
    #           :json => {:status=>"Failure",:message=>"SurName is required"}
    #    return
    # end
    if params[:mobile_no].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Mobile is required"}
       return
    end
    if params[:gender].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Gender is required"}
       return
    end
    if params[:password].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Password is required"}
       return
    end
    if params[:dob].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Birthday is required"}
       return
    end
    if params[:terms_and_condition].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Terms and Condition is required"}
       return
    end
    if params[:email].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Email Address is required"}
       return
    else
      user_exist = User.find_by_email(params[:email])  
      if user_exist.present?
        render :status => 400,
                :json => {:status=>"Failure",:message=>"Another account is already using this email address"}
        return
      end   
    end
    if params[:device_token].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"device token cant be blank."}
       return
    end

#    if params[:password_confirmation].blank?
#      render :status => 400,
#              :json => {:status=>"Failure",:message=>"Password Confirmation is required"}
#       return
#    end
    @user = User.new({:email => params[:email],
          :username => params[:username],
          :surname => params[:surname],
          :mobile_no => params[:mobile_no],
          :gender => params[:gender],
          :dob => params[:dob],
          :password => params[:password],
          :status => true,
          :terms_and_condition => params[:terms_and_condition],
          :type => 'Patient'
                })
    @user.skip_confirmation!
    if @user.save

      device = Device.where(:token => params[:device_token]).first
      if device.present?
        device.update_column(:user_id, @user.id)
      else
        Device.create(:user_id => @user.id, :token => params[:device_token], :device_type => params[:device_type])
      end
        
      #@user.confirm!
      sign_in @user, store: true
      render :status=>200, :json=>{:status=>"Success",
             :user => @user.patient_response_data,
             :via => 'signup',
             :message= => 'Signup Successfully'
             }
    else
      logger.info @user.errors.inspect
      render :status => 200, :json => { :status=>"Failure",:message=>"Registeration Failed Error: #{@user.errors.values.join(", ")}."}
    end
  end
  
  
  def doctor_sign_up
    if params[:username].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Name is required"}
       return
    end
    if params[:licence].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Licence is required"}
       return
    end
    # if params[:terms_and_condition].blank?
    #   render :status => 400,
    #           :json => {:status=>"Failure",:message=>"Terms and Condition is required"}
    #    return
    # end
    if params[:specialize].blank?
      render :status => 400,
            :json => {:status=>"Failure",:message=>"specialize is required"}
      return
    end
    if params[:password].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Password is required"}
       return
    end
    if params[:city].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"City is required"}
       return
    end
    if params[:country].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Country is required"}
       return
    end
    if params[:mobile_no].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Mobile Number is required"}
       return
    end    
    if params[:email].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Email Address is required"}
       return
    else
      user_exist = User.find_by_email(params[:email])  
      if user_exist.present?
        render :status => 400,
                :json => {:status=>"Failure",:message=>"Another account is already using this email address"}
        return
      end   
    end
#    if params[:password_confirmation].blank?
#      render :status => 400,
#              :json => {:status=>"Failure",:message=>"Password Confirmation is required"}
#       return
#    end
    @user = User.new({:username => params[:username],
          :city => params[:city],
          :licence => params[:licence],
          :specialize => params[:specialize],
          :email => params[:email],
          :country => params[:country],
          :mobile_no => params[:mobile_no],
          :terms_and_condition => params[:terms_and_condition],
          :password => params[:password],
          :status => nil,
          :type => 'Doctor'
                })
    @user.skip_confirmation!
    if @user.save
      #@user.confirm!
      #sign_in @user, store: true
      render :status => 200, :json => { :status=>"Success",
             :user => @user.doctor_response_data,
             :via => 'signup',
             :message => 'Signup Successfully'
              }

    else
      logger.info @user.errors.inspect
      render :status => 200, :json => { :status=>"Failure",:message=>"Registeration Failed Error: #{@user.errors.values.join(", ")}."}
    end
  end
  
  
  
  def twitter_authentication
    if params[:screen_name].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Screen Name is required"}
       return
    end
    if params[:username].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"UserName is required"}
       return
    end
    if params[:mobile_no].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Mobile is required"}
       return
    end
    if params[:gender].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Gender is required"}
       return
    end
    if params[:dob].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Birthday is required"}
       return
    end
    if params[:uid].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"UID is required"}
       return
    end
    if params[:access_token].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Access Token is required"}
       return
    end
    if params[:terms_and_condition].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Terms and Condition is required"}
       return
    end

    if params[:device_token].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"device token cant be blank."}
       return
    end
    
    @user = User.where(:provider => 'twitter', :uid => params[:uid]).first
#    @user = User.where(:email => params[:email]).first
    if !@user.present?
      @user = User.new(:username => params[:username],
            :provider => "twitter",
            :uid => params[:uid],
            :email => params[:screen_name] + "@twitter.com",
            :password => Devise.friendly_token[0,20],
            :authentication_token => params[:access_token],
            :surname => params[:surname].present? ? params[:surname] : " ",
            :dob => params[:dob],
            :gender => params[:gender],
            :status => true,
            :type => 'Patient',
            :terms_and_condition => params[:terms_and_condition],
            :image => params[:image_url]
          )
      @user.skip_confirmation!
      if @user.save
        
        device = Device.where(:token => params[:device_token]).first
        if device.present?
          device.update_column(:user_id, @user.id)
        else
          Device.create(:user_id => @user.id, :token => params[:device_token], :device_type => params[:device_type])
        end

        sign_in @user, store: true
        render :status=>200, :json=>{ :status=>"Success",
                   :user => @user.patient_response_data,
                   :via => 'twitter',
                   :message => "Registeration Success."
                 } 
      else
        logger.info @user.errors.inspect
        render :status => 200, :json=>{ :status=>"Failure",:message=>"Registeration Failed Error: #{@user.errors.full_messages.join(", ")}."}
      end
    else
#      if @user.update_attributes(:authentication_token => params[:access_token], :uid => params[:uid])
      #if @user.status?
      @user.authentication_token = params[:access_token]
      @user.uid = params[:uid] if params[:uid].present?
      ###########################To update profile pic from Twitter image#########################
      @user.image = params[:image_url] if @user.image.blank?
      #######################################################################################
      if @user.save
        device = Device.where(:token => params[:device_token]).first
        if device.present?
          device.update_column(:user_id, @user.id)
        else
          Device.create(:user_id => @user.id, :token => params[:device_token], :device_type => params[:device_type])
        end
        sign_in @user, store: true
        render :status=>200, :json=>{:status=>"Success", 
                      :user => @user.patient_response_data,
                      :via => 'twitter',
                      :message => "Signin Successfully."}      
      else
        logger.info @user.errors.inspect
        render :status=>200, :json=>{ :status=>"Failure",:message=>"Login Failed Error: #{@user.errors.full_messages.join(", ")}."}
      end 
      #else
      #  render :status=>401, :json=>{:status=>"Failure",:message=>"This account has been Blocked - Please Contact Admin."}
      #  return
      #end    
    end
  end 
  
  
  
  def facebook_authentication
    if params[:username].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Name is required"}
       return
    end
#    if params[:surname].blank?
#      render :status => 400,
#              :json => {:status=>"Failure",:message=>"SurName is required"}
#       return
#    end
    if params[:mobile_no].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Mobile is required"}
       return
    end
    if params[:gender].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Gender is required"}
       return
    end
    if params[:dob].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Birthday is required"}
       return
    end
    if params[:uid].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"UID is required"}
       return
    end
    if params[:access_token].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Access Token is required"}
       return
    end
    if params[:terms_and_condition].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Terms and Condition is required"}
       return
    end
    if params[:device_token].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"device token cant be blank."}
       return
    end

    @user = User.where(:email => params[:email]).first
    if !@user.present?
      @user = User.new(:username => params[:username],
            :provider => "facebook",
            :uid => params[:uid],
            :email => params[:email],
            :password => Devise.friendly_token[0,20],
            :authentication_token => params[:access_token],
            :surname => " ",
            :dob => params[:dob],
            :gender => params[:gender],
            :status => true,
            :type => 'Patient',
            :terms_and_condition => params[:terms_and_condition],
            :image => params[:image_url]
          )
      @user.skip_confirmation!
      if @user.save

        device = Device.where(:token => params[:device_token]).first
        if device.present?
          device.update_column(:user_id, @user.id)
        else
          Device.create(:user_id => @user.id, :token => params[:device_token], :device_type => params[:device_type])
        end

        sign_in @user, store: true
        render :status=>200, :json=>{ :status=>"Success",
                        :user => @user.patient_response_data,
                        :via => 'facebook',
                        :message => "Registeration Success."}
      else
        logger.info @user.errors.inspect
        render :status => 200, :json=>{ :status=>"Failure",:message=>"Registeration Failed Error: #{@user.errors.full_messages.join(", ")}."}
      end
    else
      #if @user.status?
      @user.authentication_token = params[:access_token]
      @user.uid = params[:uid] if params[:uid].present?
      ###########################To update profile pic from FB image#########################
      @user.image = params[:image_url] if @user.image.blank?
      #######################################################################################        
      if @user.save

        device = Device.where(:token => params[:device_token]).first
        if device.present?
          device.update_column(:user_id, @user.id)
        else
          Device.create(:user_id => @user.id, :token => params[:device_token], :device_type => params[:device_type])
        end

#      if @user.update_without_password(:authentication_token => params[:access_token], :uid => params[:uid])
        sign_in @user, store: true
        render :status=>200, :json=> {:status=>"Success", 
                  :user => @user.patient_response_data,
                   :via => 'facebook',
                   :message => 'Signin Successfully'
               }      
      else
        logger.info @user.errors.inspect
        render :status=>200, :json=>{ :status=>"Failure",:message=>"Login Failed Error: #{@user.errors.full_messages.join(", ")}."}
      end 
      #else
      #  render :status=>401, :json=>{:status=>"Failure",:message=>"This account has been Blocked - Please Contact Admin."}
      #  return
      #end    
    end
  end
  
  
end


