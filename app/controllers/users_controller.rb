class UsersController < ApplicationController
  
  before_action :load_filter, :except => [:forget_password_request]
  #skip_before_action :authenticate_user!
  
  def user_profile
    @user = User.find(params[:id]) rescue nil
    if @user.present?
      if @user.type == 'Doctor'
        render :status=>200, :json=>{:status=>"Success",
               :user_image_url => @user.image.url(:small),
               :full_name => @user.full_name,
               :specility => @user.specialize,
               :email => @user.email,
               :phone_no => @user.mobile_no
               }
      else
        render :status=>200, :json=>{:status=>"Success",
               :user_image_url => @user.image.url(:small),
               :full_name => @user.full_name,
               :email => @user.email,
               :phone_no => @user.mobile_no
               }
      end
    else
      render :status=>401,
            :json=>{:status=>"Failure",:message=>"User Not Found."}  
    end
  end
  
  def card_details
    @user = current_user
    if @user.present?
      @card_detail = @user.card_details.last
      if @card_detail.present?
        render :status=>200, :json=>{:status=>"Success",
               :email => @user.email,
               :card_number => @card_detail.number,
               :validity => @card_detail.validity,
               :cvv => @card_detail.cvv,
               :phone_no => @user.mobile_no
               }
      else
        render :status=>200,
            :json=>{:status=>"Failure",:message=>"NO Record Found."}  
      end
    else
      render :status=>200,
            :json=>{:status=>"Failure",:message=>"User Not Found."}  
    end
  end
  
  def verify_for_payment
    @user = current_user
    if params[:verification_code].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Verificatin Code is required"}
       return
    end
    if params[:card_id].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Card Id is required"}
       return
    end
    if @user.present?
      @card_detail = @user.car_details.find(params[:card_id]) rescue nil
      if @card_detail.present? and @user.verification_code == params[:verification_code]
        render :status=>200, :json=>{:status=>"Success",
               :card_number => @card_detail.number,
               :validity => @card_detail.validity,
               :cvv => @card_detail.cvv,
               :phone_no => @user.mobile_no
               }
      else
        render :status=>404,
              :json=>{:status=>"Failure",:message=>"Card Number or Verification Code incorrent."}  
      end
    else
      render :status=>401,
            :json=>{:status=>"Failure",:message=>"User Not Found."}  
    end
  end
  
  def save_card_details
    @user = current_user
    if @user.present?  
      if params[:card_number].blank?
        render :status => 200,
                :json => {:status=>"Failure",:message=>"Card Number is required"}
         return
      end
      if params[:validity].blank?
        render :status => 200,
                :json => {:status=>"Failure",:message=>"validity Date is required"}
         return
      end
      if params[:cvv].blank?
        render :status => 200,
                :json => {:status=>"Failure",:message=>"CVV is required"}
         return
      end
      @card = CardDetail.new(:number => params[:card_number],
            :validity => params[:validity],
            :cvv => params[:cvv],
            :card_type => params[:card_type],
            :user_id => @user.id
                )
      if @card.save
        render :status => 200, :json => { :status=>"Success",
                :message => 'Saved Successfully'
                }
      else
        logger.info @card.errors.inspect
        render :status => 200, :json => { :status=>"Failure",:message=>"Payment Details Saving Failed : Error => #{@card.errors.values.join(", ")}."}
      end
    else
      render :status=>401,
          :json=>{:status=>"Failure",:message=>"User Not Found."}  
    end
  end
  
  def forget_password_request
    if params[:email].nil?
      render :status=>400,:json=>{:status=>"Failure",:message=>"The request must contain email."}
      return
    end
    @user = User.find_by_email(params[:email].downcase)
    if @user.present?
      #str = SecureRandom.hex(3)+Time.now.to_i.to_s
      str = @user.email.first(4)
      str = str + (@user.dob.present? ? @user.dob.strftime('%d%m') : '1234')
      @user.password = str
      if @user.save(:validate => false)
        UserMailer.forget_password_request(@user, str).deliver!
        render :status=>200,:json=>{:status=>"Success",:message=>"Your password sent to your email address"}
      end      
    else
      render :status=>401,:json=>{:status=>"Failure",:message=>"User Not Found."}
    end
  end
  
  def edit_profile
    @user = Patient.find_by_email(params[:email]) || Patient.find_by_id(params[:id])
    @user = current_user if @user.blank?
    if @user.present?
      render :status=>200, :json=>{:status=>"Success",
             :user => @user.patient_response_data}
    else
      render :status=>401,
            :json=>{:status=>"Failure",:message=>"User Not Found."}  
    end
  end


  def edit_doctor_profile
    @user = Doctor.find_by_email(params[:email]) || Doctor.find_by_id(params[:id])
    @user = current_user if @user.blank?
    if @user.present?
      render :status=>200, :json=>{:status=>"Success",
             :user => @user.doctor_response_data}
    else
      render :status=>401,
            :json=>{:status=>"Failure",:message=>"User Not Found."}  
    end
  end

  
  def update_details
    @user = Patient.find_by_email(params[:email]) || Patient.find_by_id(params[:id])
    @user = current_user if @user.blank?
    if @user.present?
      @user.username = params[:username] if params[:username].present?
      @user.surname = params[:surname] if params[:surname].present?
      @user.mobile_no = params[:mobile_no] if params[:mobile_no].present?
      @user.dob = params[:dob] if params[:dob].present?
      @user.gender = params[:gender] if params[:gender].present?
      @user.height = params[:height] if params[:height].present?
      @user.weight = params[:weight] if params[:weight].present?
      @user.blood_group = params[:blood_group] if params[:blood_group].present?
      @user.zip_code = params[:zip_code] if params[:zip_code].present?
      @user.city = params[:city] if params[:city].present?
      @user.street = params[:street] if params[:street].present?
      @user.state = params[:state] if params[:state].present?
      @user.country = params[:country] if params[:country].present?
      @user.med_notes = params[:med_notes] if params[:med_notes].present?
      @user.image = params[:image_url] if params[:image_url].present?
      if @user.save
        render :status=>200, :json=>{:status=>"Success",
               :user => @user.patient_response_data,
               :message => "updated successfully"
               }
        
      else
        puts @user.errors
       render :status => 200, :json => { :status=>"Failure",:message=>"Update Failed Error: #{@user.errors.full_messages.join(", ")}."}
      end
    else
      render :status=>401,
            :json=>{:status=>"Failure",:message=>"User Not Found."}
    end
  end


  def update_doctor_details
    @user = Doctor.find_by_email(params[:email]) || Doctor.find_by_id(params[:id])
    @user = current_user if @user.blank?
    if @user.present?
      @user.username = params[:username] if params[:username].present?
      @user.surname = params[:surname] if params[:surname].present?
      @user.mobile_no = params[:mobile_no] if params[:mobile_no].present?
      @user.dob = params[:dob] if params[:dob].present?
      @user.gender = params[:gender] if params[:gender].present?
      @user.zip_code = params[:zip_code] if params[:zip_code].present?
      @user.state = params[:state] if params[:state].present?
      @user.city = params[:city] if params[:city].present?
      @user.street = params[:street] if params[:street].present?
      @user.country = params[:country] if params[:country].present?
      @user.specialize = params[:specialize] if params[:specialize].present?
      @user.licence = params[:licence] if params[:licence].present?
      @user.image = params[:image_url] if params[:image_url].present?
      if @user.save
        render :status=>200, :json=>{:status=>"Success",
               :user => @user.doctor_response_data,
               :message => "updated successfully"
               }
        
      else
       render :status => 200, :json => { :status=>"Failure",:message=>"Update Failed Error: #{@user.errors.full_messages.join(", ")}."}
      end
    else
      render :status=>401,
            :json=>{:status=>"Failure",:message=>"User Not Found."}
    end
  end
  
  def charge_payment
    if params[:email].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Email is required"}
       return
    end
    if params[:stripeToken].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"stripeToken is required"}
       return
    end
    if params[:amount].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"amount is required"}
       return
    end
    user = User.find_by_email(params[:email]) || User.find_by_id(params[:id])
    begin
      stripe_customer = Stripe::Customer.create(
      :email => params[:email],
      :card  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
      :customer    => stripe_customer.id,
      :amount      => params[:amount].to_i,
      :description => user.name,
      :currency    => 'MXN'
      )
      
    rescue Stripe::CardError => e
      flash[:error] = e.message
      render :status=>200, :json=>{:status=>"Failure",
               :message => "Payment not done"
               }
    end
    p = Payment.new(:user_id => user.id, :amount => charge.amount, :payment_date => Time.now, :txnid => Time.now.to_i.to_s, :status => 'success', :payment_type => 'online')
    p.save
    render :status=>200, :json=>{:status=>"Success",
       :charge_id => charge.id,
       :user_id => user.id,
       :txnid => Time.now.to_i.to_s,
       :amount => charge.amount,
       :currency    => 'MXN',
       :message => "Successfully Charged"
       }
    
    #if charge.present?
    #  @order.confirm!
    #end
    #return redirect_to orders_vcpayment_path
  end

end
