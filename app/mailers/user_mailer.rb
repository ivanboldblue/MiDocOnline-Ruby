class UserMailer < ActionMailer::Base
#  default from: "info@midoconline.com"
  add_template_helper(ApplicationHelper)
  
  
  def notify_admin_about_doctor_sign_up(doctor)
    @doctor = doctor
    mail(:to => "#{ADMIN_EMAIL}", :bcc => "#{EMAIL_BCC}", :subject => "Doctor Sign Up Notification", :from => 'info@midoconline.com')
  end
  
  def notify_doctor_about_approval(doctor)
    @doctor = doctor
    mail(:to => @doctor.email, :bcc => "#{EMAIL_BCC}", :subject => "Activated your Midoconline account.", :from => 'info@midoconline.com')
  end

  def notify_doctor_about_rejection(doctor)
    @doctor = doctor
    mail(:to => @doctor.email, :bcc => "#{EMAIL_BCC}", :subject => "Rejected your Midoconline account.", :from => 'info@midoconline.com')
  end
  
  def forget_password_request(user, str)
    @user = user
    @str = str
#    I18n.locale = locale
    mail(:to => @user.email, :bcc => "#{EMAIL_BCC}", :subject => (UserMailer.lt("Forget Password Request")), :from => 'info@midoconline.com')
  end
  
  def self.lt(text)
#    name = text.strip
#    key = StaticPageContent.create_key(name)
#    if !(I18n.t "#{key}").include?("translation_missing")
#      name = I18n.t "#{key}"
#    end
    return text
  end
end
