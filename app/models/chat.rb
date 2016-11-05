class Chat < ActiveRecord::Base
  
  belongs_to :patient
  belongs_to :doctor
  belongs_to :history
  belongs_to :user#, :foreign_key => :created_by, :class_name => 'User'

  validates :patient_id, :doctor_id, :message, :history_id, :user_id,
            :presence =>true 


end
