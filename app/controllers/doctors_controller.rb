class DoctorsController < ApplicationController
  
  before_action :load_filter
  skip_before_action :load_filter, :only => [:view_doctors_list]

  #skip_before_action :verify_authenticity_token
  before_action :authenticate_admin, :only => [:index, :create, :destroy, :pending_list, :delete_doctor, :update_doctor_status] #, :except => [:profile, :history, :localization]
  skip_before_action :authenticate_admin, :except => [:localization]
  layout 'new_admin'

  
  def index
    @doctors = Doctor.order("created_at desc").to_json
    respond_to do |format|
      format.html {}
      #format.xls do
       # @patients = Patient.all
        #only_columns = [:id, :user_id, :description, :challenge_id]
        #method_allowed = [:suggested_user_name, :suggested_user_email, :suggested_date, :suggested_status, :challenge_name]
        #send_data @patients.to_xls(:only => only_columns, :methods => method_allowed)
      #end
    end
  end

  def profile
    @user = current_user
    if @user.blank?
      redirect_to root_path
    end
    render :layout =>  'users'
  end

  def history
    @user = current_user
    @history = History.where('receiver_id = ? or caller_id = ?', current_user.id, current_user.id).where('call_status = ?', 'completed')
    @history = @history.where('date(created_at) >= ?', params[:from_date].to_date) if params[:from_date].present?
    @history = @history.where('date(created_at) <= ?', params[:to_date].to_date) if params[:to_date].present?
    @blogpost = NewsPost.where(:post_type => 'blog').last(3)
    @posts = NewsPost.where(:post_type => 'news').order('created_at desc')
    render :layout =>  'users'
  end

  def doctor_history
    @history = History.where('receiver_id = ? or caller_id = ? and call_status = ?', current_user.id, current_user.id, 'completed')
    render :status=>200, :json=>{:status=>"Success",
             :history => @history.map{|h| h.response_data}
             }
  end

  def localization
    @user = current_user
    render :layout =>  'users'
  end


  def show
    @doctor = Doctor.unscoped.find(params[:id])
    @histories = History.where('receiver_id = ? and call_status = ?', @doctor.id, 'completed')
    @histories = @histories.order('started_time desc').paginate(:page => params[:page], :per_page => 20)
    @grouped_histories = @histories.group_by {|u| u.started_time.strftime('%d/%m/%Y') }
  end

  def edit
    @doctor = Doctor.unscoped.find(params[:id])
  end
  
  def pending_list
    @pending_doctors = Doctor.unscoped.where(:status => [nil]).order("created_at desc").to_json
    respond_to do |format|
      format.html {}
    end
  end
  
  def update_doctor_status
    @doctor = Doctor.unscoped.find(params[:id])
    if (params[:status].present? and params[:status] == 'false') or (params[:status].present? and params[:status] == false)
      @doctor.update_attributes(:status => false)
    else
      @doctor.update_attributes(:status => true)
    end
    if params[:status].present? and params[:status] == 'false' or params[:status].present? and params[:status] == false 
      redirect_to :back, :notice => 'Doctor was successfully Rejected.'
    else
      redirect_to :back, :notice => 'Doctor was successfully Approved.'
    end
  end
  
  
  def view_doctors_list
    per_page = params[:per_page].to_i == 0 ? 30 : params[:per_page].to_i
    @doctors = Doctor.scoped
    if params[:specialize].present?
      @doctors = @doctors.where(:specialize => params[:specialize])
    end
    if params[:specialize].present? and params[:specialize] == 'emergency'
      @doctors = @doctors.where(:emergency => params[:specialize])
      @doctors = @doctors.where('from_time < ?', Time.now)
      @doctors = @doctors.where('to_time > ? or to_time IS NULL', Time.now)
    end
    @total_pages = (@doctors.count / per_page).ceil
    @doctors = @doctors.paginate(:page => params[:page], :per_page => per_page)
      render :status=>200, :json=>{:status=>"Success",
             :total_pages => @total_pages,
             :doctors => @doctors.map{|d| d.doctor_response_data}}
#    else
#      render :status=>401,
#              :json=>{:status=>"Failure",:message=>"Challenge Not Found."}
#    end
  end
  
  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy
    redirect_to :back, :notice => 'Doctor was successfully deleted.'
  end
  
  def delete_doctor
    @doctor = Doctor.unscoped.find(params[:id])
    @doctor.destroy
    redirect_to :back, :notice => 'Doctor was successfully deleted.'
  end

  def update
    @doctor = Doctor.find(params[:id])
    # params[:doctor] = params[:doctor].merge(:gender => request.env["rack.request.form_hash"]['action'])
    respond_to do |format|
      if @doctor.update_attributes(doctor_params)
        format.js {}
        if current_user.admin?
          format.html {redirect_to doctors_path, :notice => 'Doctor was successfully updated.', :layout => 'users'}
        else
          format.html {redirect_to profile_doctor_path(@doctor), :notice => 'Doctor was successfully updated.', :layout => 'users'}
          format.json { render :json => { :success => "true", :user => @doctor }}
        end
      else
        format.js
        format.html{ render :action => "edit", :layout => 'new_admin' }
        format.json { render :json => {"value" => "fail", "errors" => @doctor.errors } }
      end
    end
  end

  protected 

  def doctor_params
    params.require(:doctor).permit!#(:name, :display_name, :launch_date, :image, :status)
  end
  
end
