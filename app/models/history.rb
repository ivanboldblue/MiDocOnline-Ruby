class History < ActiveRecord::Base

  validates :receiver_id, :caller_id, :started_time, :chat_type,
            :presence => true

  belongs_to :caller, :foreign_key => :caller_id, :class_name => 'User'
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => 'User'
  has_many :chats

  before_create :update_call_status_and_time
  # after_save :push_notification

  default_scope { order("created_at desc") }

  def update_call_status_and_time
    if self.call_status.blank?
      self.call_status = 'pending'
    end
    if self.started_time.blank?
      self.started_time = Time.now
    end
  end

  # def push_notification
  #   if self.call_status == 'pending'
  #     receiver = self.receiver
  #     msg = "You missed call from #{self.patient.username}"
  #     if receiver.present?
  #       receiver.push_notifications(msg, 'History', self.id)
  #     end
  #   end
  # end

  def self.push_notification_about_call_missed
    @histories = History.where(:call_status => 'pending', :notified => nil)
    Rails.logger.info("***************Notify Call missed*********#{Time.now}*********************")
      puts "*************Notify Call missed********#{Time.now}**********************"
    if @histories.present?
      @histories.each do |history|
        receiver = history.receiver
        history.update_column(:notified, true)
        msg = "You missed call from #{self.patient.username}"
        if receiver.present?
          receiver.push_notifications(msg, 'History', self.id)
        end
      end
    end
  end



  def response_data
    Hash[*JSON.parse(self.to_json(:only=> [:caller_id, :receiver_id, :qb_caller_id, :qb_receiver_id, :chat_type, :duration, :call_status, :amount, :currency], :methods => [:doctor_id, :patient_id, :doctor_email, :patient_email, :doctor_full_name, :patient_full_name, :doctor_specialization, :call_date])).map{|k, v| [k, v || ""]}.flatten]
  end

  def doctor_specialization
    if self.receiver.type == 'Doctor'
      self.receiver.specialize rescue nil
    else
      self.caller.specialize rescue nil
    end
  end

  def call_date
    self.created_at.strftime('%d/%m/%Y %H:%M')
  end


  def doctor_full_name
    if self.receiver.type == 'Doctor'
      self.receiver.username rescue nil
    else
      self.caller.username rescue nil
    end
  end

  def doctor_speciality
    if self.receiver.type == 'Doctor'
      self.receiver.specialize rescue nil
    else
      self.caller.specialize rescue nil
    end
  end

  def doctor_id
    if self.receiver.type == 'Doctor'
      self.receiver.id rescue nil
    else
      self.caller.id rescue nil
    end
  end

  def doctor_email
    if self.receiver.type == 'Doctor'
      self.receiver.email rescue nil
    else
      self.caller.email rescue nil
    end
  end

  def patient_id
    if self.receiver.type == 'Patient'
      self.receiver.id rescue nil
    else
      self.caller.id rescue nil
    end
  end

  def patient_email
    if self.receiver.type == 'Patient'
      self.receiver.email rescue nil
    else
      self.caller.email rescue nil
    end
  end

  def patient_full_name
    if self.receiver.type == 'Patient'
      self.receiver.username rescue nil
    else
      self.caller.username rescue nil
    end
  end


end
