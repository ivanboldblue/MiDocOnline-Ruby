class VideoChatsController < ApplicationController
  require "quickblox"
  
  layout 'users'

  before_action :load_filter, :except => [:update_web_call_history, :create_history]
  skip_before_action :authenticate_user!, :only => [:update_web_call_history, :create_history]
#  before_action :check_payment, :only => [:index]

  def check_payment
    if current_user.present? and current_user.type == 'Doctor'
    
    else
      if (session[:reload_count].present? and session[:reload_count].to_i > 2) or session[:charge_customer_id].blank?
        redirect_to landing_patients_path #history_patient_path(:id => current_user.id)#new_charge_path
      else
        session[:reload_count] = session[:reload_count].to_i + 1
        # session.delete('charge_customer_id')
      end
    end
  end

  def doctor_listing
    @user = current_user
    @qb_doctors = User.where('qb_user_id IS NOT NULL and admin IS NOT true')
    if current_user.type == 'Doctor'
      user_ids = History.where(:receiver_id => current_user.id).pluck(:caller_id)
      @qb_doctors = @qb_doctors.where(:id => user_ids)

    end
    if params[:caller_id].present?
      @qb_doctors = User.where(:id => params[:caller_id])
    else 
      if params[:specialize].present? and ['kids', 'adult'].exclude? params[:specialize]
        @qb_doctors = @qb_doctors.where(:specialize => params[:specialize])
      end
      if params[:specialize].present? and ['kids', 'adult'].include? params[:specialize]
        @qb_doctors = @qb_doctors.where(:emergency => params[:specialize])
      end  
    end
  end
	

  def index
    @user = current_user
    @qb_doctors = User.where('qb_user_id IS NOT NULL and admin IS NOT true')
    if current_user.type == 'Doctor'
      user_ids = History.where(:receiver_id => current_user.id).pluck(:caller_id)
      @qb_doctors = @qb_doctors.where(:id => user_ids)

    end
    if params[:caller_id].present?
      @qb_doctors = User.where(:id => params[:caller_id])
    else 
      if params[:specialize].present? and ['kids', 'adult'].exclude? params[:specialize]
        @qb_doctors = @qb_doctors.where(:specialize => params[:specialize])
      end
      if params[:specialize].present? and ['kids', 'adult'].include? params[:specialize]
        @qb_doctors = @qb_doctors.where(:emergency => params[:specialize])
        #@qb_doctors = @qb_doctors.where('from_time < ? or from_time IS NULL', Time.now)
        #@qb_doctors = @qb_doctors.where('to_time > ? or to_time IS NULL', Time.now)
      end  
    end
    # @qb_doctors = Doctor.all if @qb_doctors.blank?#.where('specialize IN (?) and qb_user_id IS NOT NULL', ['kids', 'adult']) || User.all
    @qb_doctors = @qb_doctors.map{|u| u.qb_user_json_data}
    @hsh = []
    @qb_doctors.each do |d|
      if current_user.qb_user_id != d['qb_user_id']
        h = {id:d['qb_user_id'], login:d['qb_login'], password:d['qb_password'], full_name:d['username'], colour:d['type']}
        @hsh << h
      end
    end
  end

  def create
    if params[:receiver_email].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Receiver Email is required"}
       return
    end
    # if params[:receiver_id].blank?
    #   render :status => 400,
    #           :json => {:status=>"Failure",:message=>"Doctor Id is required"}
    #    return
    # end
    if params[:caller_id].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Patient Id is required"}
       return
    end
    if params[:started_time].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Patient Id is required"}
       return
    end
    if params[:chat_type].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Chat Type is required"}
       return
    end
    @receiver = User.find_by_email(params[:receiver_email])
    @caller = User.find_by_email(params[:caller_id])
    if @receiver.present? and @caller.present?
      amount = (params[:amount].to_i / 100)
      @history = History.new(:caller_id => @caller.id, :receiver_id => @receiver.id, :started_time => params[:started_time], :chat_type => params[:chat_type], :call_status => 'started', :amount => amount, :currency => params[:currency], :qb_caller_id => params[:qb_caller_id], :qb_receiver_id => params[:qb_receiver_id])
      if @history.save
        render :status=>200, :json=>{:status=>"Success",
               :id => @history.id,
               :caller_id => @history.caller_id,
               :receiver_id => @history.receiver_id,
               :qb_caller_id => @history.qb_caller_id,
               :qb_receiver_id => @history.qb_receiver_id,
               :amount => @history.amount,
               :currency => @history.currency,
               :chat_type => @history.chat_type,
               :started_time => @history.started_time,
               :message= => '1st step completed'
               }
      else
        logger.info @history.errors.inspect
        render :status => 200, :json => { :status=>"Failure",:message=>"History saved Failed Error: #{@history.errors.full_messages.join(", ")}."}
      end
    else
      render :status => 404, :json => { :status=>"Failure",:message=>"Receiver Not Found."}
    end  
  end

  def create_history
    @receiver = User.find_by_qb_user_id(params[:qb_receiver_id])
    @caller = User.find_by_qb_user_id(params[:qb_caller_id])
    if @receiver.present?
      @history = History.new(:caller_id => @caller.id, :receiver_id => @receiver.id, :started_time => Time.now, :chat_type => params[:chat_type], :call_status => 'started', :amount => 40, :currency => 'usd', :qb_caller_id => params[:qb_caller_id], :qb_receiver_id => params[:qb_receiver_id])
      respond_to do |format|
        if @history.save
          session[:history_id] = @history.id
          format.js{render :text => 'ok'}
        else
          format.js{render :text => 'ok'}
        end
      end
    else
      render :status => 404, :json => { :status=>"Failure",:message=>"Receiver Not Found."}
    end  
  end

  def update_web_call_history
    if params[:duration].present?
      @history = History.where('qb_caller_id = ? or qb_receiver_id = ?', params[:qb_receiver_id], params[:qb_receiver_id]).first
    else
      @history = History.where(:qb_caller_id => params[:qb_caller_id], :qb_receiver_id => params[:qb_receiver_id]).first
    end
    #@history = History.find_by_id(session[:history_id]) || History.where(:qb_caller_id => params[:qb_caller_id], :qb_receiver_id => params[:qb_receiver_id]).last
    if @history.present?
      if params[:duration].present?
        @amount = 70000
        charge = Stripe::Charge.create(
        :customer    => session[:charge_customer_id],
        :amount      => @amount,
        :description => 'Video call charge',
        :currency    => 'mxn'
        )
        session[:charge_customer_id] = nil
        session.delete(:charge_customer_id)

        @history.call_status = 'completed' if @history.call_status == 'received'
        @history.duration = ((Time.now.to_i - @history.started_time.to_i) / 3600.0)
      elsif params[:call_status].present? and params[:call_status] == 'received'
        @history.call_status = 'received'
      end
      respond_to do |format|
        if @history.save
          if params[:duration].present?
            if current_user.present? and current_user.type == 'Patient'
              format.js{render :js => "window.location.href = '#{landing_patients_path}'" }
            else
              format.js{render :js => "window.location.href = '#{video_chats_path}'" }
            end
          else
            format.js{render :text => 'ok'}
          end
        else
          format.js{render :text => 'ok'}
        end
      end
    end  
  end


  def update_history
    if params[:call_status].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Call Status is required"}
       return
    end
    if params[:duration].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Duration is required"}
       return
    end
    @history = History.find_by_id(params[:id])
    if @history.present?
      @history.update_attributes(:call_status => params[:call_status], :duration => params[:duration])
      render :status=>200, :json=>{:status=>"Success",
             :caller_id => @history.caller_id,
             :receiver_id => @history.receiver_id,
             :qb_caller_id => @history.qb_caller_id,
             :qb_receiver_id => @history.qb_receiver_id,
             :amount => @history.amount,
             :currency => @history.currency,
             :chat_type => @history.chat_type,
             :started_time => @history.started_time,
             :duration => @history.duration,
             :call_status => @history.call_status,
             :message= => '3rd step completed'
             }
    else
      render :status => 200, :json => { :status=>"Failure",:message=>"History Not Found"}
    end
  end

  def update_call_history
    if params[:call_status].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Call Status is required"}
       return
    end
    @history = History.find_by_id(params[:id])
    if @history.present?
      @history.update_attributes(:call_status => params[:call_status], :notified => false)
      render :status=>200, :json=>{:status=>"Success",
             :caller_id => @history.caller_id,
             :receiver_id => @history.receiver_id,
             :qb_caller_id => @history.qb_caller_id,
             :qb_receiver_id => @history.qb_receiver_id,
             :amount => @history.amount,
             :currency => @history.currency,
             :chat_type => @history.chat_type,
             :started_time => @history.started_time,
             :call_status => @history.call_status,
             :message= => '2nd step completed'
             }
    else
      render :status => 200, :json => { :status=>"Failure",:message=>"History Not Found"}
    end
  end

  def update_call_status
    if params[:receiver_email].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Receiver Email is required"}
       return
    end
    # if params[:receiver_id].blank?
    #   render :status => 400,
    #           :json => {:status=>"Failure",:message=>"Doctor Id is required"}
    #    return
    # end
    if params[:caller_id].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Patient Id is required"}
       return
    end
    if params[:started_time].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Patient Id is required"}
       return
    end
    if params[:chat_type].blank?
      render :status => 400,
              :json => {:status=>"Failure",:message=>"Chat Type is required"}
       return
    end
    @history = History.new(:caller_id => params[:caller_id], :receiver_id => @receiver.id, :started_time => params[:started_time], :chat_type => params[:chat_type], :call_status => 'started', :amount => params[:amount], :currency => params[:currency], :qb_caller_id => params[:qb_caller_id], :qb_receiver_id => params[:qb_receiver_id])
  end

end
