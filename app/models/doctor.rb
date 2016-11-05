class Doctor < User
  require "quickblox"
#	has_one :customer_profile, :dependent => :destroy
#	accepts_nested_attributes_for :customer_profile
  has_and_belongs_to_many :specializations
  has_many :chats
#	has_many :activities, :foreign_key => :user_id
	
#	after_save :set_notification
	
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

  validates :city,
            :presence =>true

  validates :country,
            :presence =>true

  validates :mobile_no,
            :presence =>true

  validates :licence,
            :presence =>true


	has_many :histories
  
  after_create :notify_admin_about_doctor_sign_up
	after_save :notify_doctor_about_approval, :create_quickblox_acount, :update_quickblox_details
	
  default_scope { where(status: [true])}
  
  
 # def send_birtday_wish_mail
 #   @customers = Customer.where('Date(dob) = ?', Date.today)
 #   if @customers.present?
 #     @customers.each do |u|
 #       UserMailer.send_birtday_wish_mail_customer(u.customer).deliver
 #     end
 #   end  
 # end	
 
 
  def notify_doctor_about_approval
    if self.status_changed? and self.status?
      UserMailer.notify_doctor_about_approval(self).deliver!
    elsif self.status_changed? and self.status == false
      UserMailer.notify_doctor_about_rejection(self).deliver!
    end
  end 

  def create_quickblox_acount
    if self.status_changed? and self.status? and status == true
      m = Quickblox.new
      qb_user = m.get_user_by_email(self.email)
      if qb_user[:response_code] == '404'
        qb_user = m.signup_user(:user=>{:login=>self.email,:password=>"password",:email=>self.email,:twitter_id=>'',:external_user_id=>self.id,:tag_list=>self.emergency,:full_name=> self.username, :custom_data => self.specialize})
        qb_user = qb_user[:response_body]
      end
      if qb_user.present? and qb_user['user'].present?
        self.update_column(:qb_user_id, qb_user['user']['id'])
        self.update_column(:qb_login, qb_user['user']['login'])
        self.update_column(:qb_password, 'password')
        self.update_column(:qb_user_id, qb_user['user']['id'])
        self.update_column(:qb_name, qb_user['user']['full_name'])
      end
    end
  end

  def update_quickblox_details
    m = Quickblox.new
    qb_user = m.get_user_by_email(self.email)
    if self.emergency_changed? and qb_user[:response_code] != '404'
      m.user_login = self.email
      m.user_password = 'password'
      m.get_token
      m.update_user(:user=>{:tag_list=>self.emergency})
    end
    if qb_user.present? and qb_user['user'].present?
      self.update_column(:qb_user_id, qb_user['user']['id'])
      self.update_column(:qb_login, qb_user['user']['login'])
      self.update_column(:qb_password, 'password')
      self.update_column(:qb_user_id, qb_user['user']['id'])
      self.update_column(:qb_name, qb_user['user']['full_name'])
    end
  end

  def notify_admin_about_doctor_sign_up
    #Notification.set_notifications(self.id, User.first.id, self.class.to_s, self.id, 'Operator Sign Up')
    UserMailer.notify_admin_about_doctor_sign_up(self).deliver!
  end
  
  def full_name
    name = self.first_name
    name += " " + self.last_name if self.last_name.present?
    name.present? ? name : '' 
  end
  
  def profile_image(style=nil)
    self.image.url(style)
  end    
	
  
end

