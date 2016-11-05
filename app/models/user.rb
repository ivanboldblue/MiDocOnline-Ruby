class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
  
  
#  cattr_accessor :current_user_id
  
  #has_many  :device_tokens, :dependent => :destroy
  has_many  :card_details, :dependent => :destroy
  has_many  :payments, :dependent => :destroy
  has_many  :devices, :dependent => :destroy
  has_many  :chats, :dependent => :destroy

#  before_create :set_setings
  validates :email, 
            :uniqueness => {:message => "Another account is already using this email address"},
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message=> "Please Check Email Id" },
            :presence =>true 
            
  validates :password,
            :presence => true,
            :on => :create     
            
  validates :username,
            :presence =>true 

  validates :type,
            :presence =>true 


  has_attached_file :image, {:styles => {:large => "640x640>", :small => "150x150>", :thumb => "60x60>" }}.merge(USER_IMAGE_PATH)
  do_not_validate_attachment_file_type :image
  
  before_create :set_username, :set_user_type
  before_create :ensure_authentication_token, :generate_key
  before_create :update_status
  before_destroy :can_not_delete_admin
  after_save :update_qb_name

  def update_status
    self.status = nil if self.type == 'Doctor'
    self.status = true if self.type == 'Patient'
  end
  
  def push_notifications(msg, push_page, page_id)
    b_count = self.badge_count + 1 rescue 1
    self.update_column(:badge_count, b_count)
    devices = self.devices
    if devices.present?
      pusher = Grocer.pusher(certificate: "#{Rails.root}/lib/push_dev.pem", passphrase: "doctorapp", gateway: "gateway.sandbox.push.apple.com")
      devices.each do |device|
        notification = Grocer::Notification.new("device_token" => "#{device.token}", "alert"=>{ "title"=> "Midoconline", "body"=> msg, "action"=> "Read"}, "badge" => b_count, "sound" => "siren.aiff")
        pusher.push(notification)
      end  
    end
  end

  def can_not_delete_admin
    if self.admin
      return false
    end
  end

  def image_url
    self.image.url
  end

  def set_user_type
    if self.type.blank?
      self.type = 'Patient'
    end
  end

  def small_image_url
    self.image.url(:small)
  end

  def large_image_url
    self.image.url(:large)
  end

  def thumb_image_url
    self.image.url(:thumb)
  end

  def patient_response_data
    Hash[*JSON.parse(self.to_json(:only=> [:secret_key, :key, :authentication_token, :id, :type, :username, :surname, :email, :mobile_no, :gender, :dob, :zip_code, :street, :city, :state, :country, :blood_group, :height, :weight, :med_notes, :terms_and_condition, :qb_name, :qb_login, :qb_password, :qb_login, :qb_user_id], :methods => [:image_url, :full_name])).map{|k, v| [k, v || ""]}.flatten]
  end

  def doctor_response_data
    Hash[*JSON.parse(self.to_json(:only=> [:secret_key, :key, :authentication_token, :id, :type, :username, :email, :mobile_no, :gender, :dob, :zip_code, :street, :city, :country, :licence, :specialize, :location, :surname, :emergency, :qb_name, :qb_login, :qb_password, :qb_login, :qb_user_id], :methods => [:image_url, :full_name, :profile_image])).map{|k, v| [k, v || ""]}.flatten]
  end

  def user_response_data
    Hash[*JSON.parse(self.to_json(:only=> [:secret_key, :key, :authentication_token, :id, :type, :username, :surname, :email, :mobile_no, :gender, :dob, :zip_code, :street, :city, :state, :country, :blood_group, :height, :weight, :med_notes, :terms_and_condition, :specialize, :licence, :qb_name, :qb_login, :qb_password, :qb_login, :qb_user_id], :methods => [:image_url, :full_name])).map{|k, v| [k, v || ""]}.flatten]
  end

  def qb_user_json_data
    Hash[*JSON.parse(self.to_json(:only=> [:qb_user_id, :qb_login, :qb_password, :username, :type])).map{|k, v| [k, v || ""]}.flatten]
  end

  def update_qb_name
    if self.username.present?
      self.update_column(:qb_name, self.username)
    end
  end

  # def via(stype)
  #   case stype
  #   when 'facebook'
  #       'facebook'
  #   when 'twitter'
  #     'twitter'
  #   else
  #     'signin'
  #   end  
  # end

#  def update_user_age
#    if self.dob.present?
#      self.update_column(:age, (Date.today.year - self.dob.year))
#    end
#  end

#  def set_setings
#    self.vote_notification = true if self.vote_notification.blank?
#    self.comment_notification = true if self.comment_notification.blank?
#    self.follower_notification = true if self.follower_notification.blank?
#    self.new_challenge_notification = true if self.new_challenge_notification.blank?
#  end
  
#  def push_notifications(msg, push_page, page_id)
#    b_count = self.badge_count + 1
#    self.update_column(:badge_count, b_count)
#    devices = self.user_device_tokens
#    if devices.present?
#      pusher = Grocer.pusher(certificate: "#{Rails.root}/lib/KwalaProductionck_new.pem", passphrase: "kwalapush", gateway: "gateway.push.apple.com")
#      devices.each do |device|
#        notification = Grocer::Notification.new("device_token" => "#{device.push_device_token}", "alert"=>{ "title"=> "Kwala", "body"=> msg, "action"=> "Read"}, "badge" => b_count, "sound" => "siren.aiff", "custom" => {"push_page" => push_page, "id" => page_id})
#        pusher.push(notification)
#      end  
#    end
#  end
  
#  def update_badge_count
#    self.badge_count = 0 if self.badge_count.blank?
#  end

#  def get_loged_out
#    self.loged_out == true ? true : false
#  end

#  def get_got_it
#    self.got_it == true ? true :false
#  end

#  def send_welcome_mail
#    UserMailer.send_welcome_mail(self).deliver
#  end
  
  ###scopes
#  default_scope where(:status => true)
  
  
#  def image_url(style=nil)
#    style.present? ? self.image.url(style) : self.image.url(:original)
#  end
  
#  def small_image_url(style=nil)
#    style.present? ? self.image.url(style) : self.image.url(:small)
#  end
  
#  def thumb_image_url(style=nil)
#    style.present? ? self.image.url(style) : self.image.url(:thumb)
#  end
  
  def set_username
    if username.blank?
      self.username = self.full_name.parameterize
    end 
  end
  
  def full_name
    if self.type.present? and self.type == 'Patient'
      name = self.username
      name += " " + self.surname if self.surname.present?
    else
      name = self.username
    end
    name.present? ? name : '' 
  end      
         
          
  def self.find_for_twitter_oauth(auth , signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      email = auth.extra.raw_info.screen_name + "@twitter.com" 
      devise_user = User.where(:email => auth.info.email).first
      unless devise_user
        user = User.create(  :name => auth.extra.raw_info.name,
                             :provider => "twitter",
                             :uid => auth.uid,
                             :email => email,
                             :first_name => auth.info.first_name,
                             :last_name => auth.info.last_name,
                             :username => auth.info.nickname.present? ? auth.info.nickname.gsub(".", "-") : auth.extra.raw_info.name.parameterize.to_s + "-" + SecureRandom.hex[0..5].to_s,
                             :password => Devise.friendly_token[0,20],
                             :authentication_token => auth.credentials.token,
                             :access_token => auth["credentials"]["token"],
                             :status => true
                             #:secret => auth["credentials"]["secret"]
                          )
        logger.info user.errors.inspect
      else
        devise_user.provider = "twitter"
        devise_user.uid = auth.uid
        devise_user.name = auth.extra.raw_info.name if devise_user.name.blank?
        devise_user.save
        user = devise_user
    
      end
    end
    user.update_attributes(:authentication_token => auth.credentials.token, :uid => auth.uid)
    return user
  end
  
  
  
  def self.find_for_facebook_oauth(auth , signed_in_resource=nil)
    user = User.where(:email => auth.info.email).first
    if !user.present?
      devise_user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless devise_user
        user = User.create(:name => auth.extra.raw_info.name,
                           :provider => "facebook",
                           :uid => auth.uid,
                           :email => auth.info.email,
                           :first_name => auth.info.first_name,
                           :last_name => auth.info.last_name,
                           :username => auth.info.nickname.present? ? auth.info.nickname.gsub(".", "-") : auth.extra.raw_info.name.parameterize.to_s + "-" + SecureRandom.hex[0..5].to_s,
                           :password => Devise.friendly_token[0,20],
                           :authentication_token => auth.credentials.token,
                           :accept_condition => true,
                           :type => 'Patient',
                           :status => true
                          )
      else
        devise_user.provider = "facebook"
        devise_user.uid = auth.uid
        devise_user.name = auth.extra.raw_info.name if devise_user.name.blank?
        devise_user.accept_condition = true
        devise_user.save
        user = devise_user
      end
    else
      user.update_attributes(:authentication_token => auth.credentials.token, :uid => auth.uid)
    end
    return user
  end
  
  
 
  def generate_key
    self.key = Digest::SHA1.hexdigest(BCrypt::Engine.generate_salt)
    self.assign_secret_key
  end

  def assign_secret_key
    self.secret_key = self.get_secret_key
  end

  def ensure_authentication_token
    if self.authentication_token.blank?
      self.authentication_token = self.generate_authentication_token
    end
  end

  def get_secret_key
    Digest::SHA1.hexdigest(self.email.to_s + self.encrypted_password.to_s + self.key)
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end     
  
end
