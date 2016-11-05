class Patient < User

#	has_one :customer_profile, :dependent => :destroy
#	accepts_nested_attributes_for :customer_profile

#	has_many :activities, :foreign_key => :user_id
	
#	after_save :set_notification
  after_create :create_quickblox_acount
  
  has_many :histories	
  has_many :chats
  
  def create_quickblox_acount
    m = Quickblox.new
    qb_user = m.get_user_by_email(self.email)
    if qb_user[:response_code] == '404'
      qb_user = m.signup_user(:user=>{:login=>self.email,:password=>"password",:email=>self.email,:twitter_id=>'',:external_user_id=>self.id,:tag_list=>"",:full_name=> self.username, :custom_data => 'patient'})
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

