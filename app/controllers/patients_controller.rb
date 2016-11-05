class PatientsController < ApplicationController

  before_action :load_filter
  skip_before_action :load_filter, :only => [:localization]

#  skip_before_action :verify_authenticity_token
  before_action :authenticate_admin, :only => [:index, :create, :destroy, :delete_profile, :update_user_status, :show, :new, :edit]


  layout 'new_admin'

  def index
    @patients = Patient.unscoped.order("created_at desc").to_json
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

  def landing
    @doctors = Doctor.all
    respond_to do |format|
      format.html {render :layout => 'users'}
    end
  end
  
  def index1
    @patients = Patient.unscoped.order("username asc").to_json
#    @patients = JSON.parse(@patients)
    past_variable = ''
    users = []
    JSON.parse(@patients).each do |user|
      data = user['username'][0] rescue ""
      if data.upcase != past_variable
        past_variable = data.upcase
        hsh = {'sname' => 'block', 'username' => data.upcase}
        users << hsh
      end
      users << user
    end
    @demo = users.to_json
    @letters = ('A'..'Z').to_a.to_json
    respond_to do |format|
      format.js {}
      format.html {render :layout => 'new_admin'}

 ############## Render this when working with native API######################
 
      format.json { render status:200, :json=>{:status=>"Success",:users=> @patients}}

############## Render this when working with Phone Gap######################
#      format.json do 
#        @head_disabled = true
#        @html = render_to_string :layout => 'admin', :formats => [:html]
#        render :json => {:success => true, :value => @html.gsub('/assets', 'images') }
#      end
##############################################################################
    end
    
  end
  
  def new
    @patient = Patient.new
  end

  def show
    @patient = Patient.find(params[:id])
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
    #@history = History.where('receiver_id = ? or caller_id = ? and call_status = ?', current_user.id, current_user.id, 'completed')
    @blogpost = NewsPost.where(:post_type => 'blog').last(3)
    @posts = NewsPost.where(:post_type => 'news').order('created_at desc')
    render :layout =>  'users'
  end

  def patient_history
    @history = History.where('receiver_id = ? or caller_id = ? and call_status = ?', current_user.id, current_user.id, 'completed')
    render :status=>200, :json=>{:status=>"Success",
             :history => @history.map{|h| h.response_data},
             :message= => 'Signup Successfully'
             }
  end

  def localization
    @user = current_user
    render :layout =>  'users'
  end
  
  
  def create
    if params[:patient].present?
      @patient = Patient.new(patient_params)
      respond_to do |format|
        if @patient.save
          @patient = Json.parse(@patient)
          format.js {}
          format.html {redirect_to admin_users_path, :notice => 'Patient was successfully created.'}
          format.json { render :json => { :success => "true", :user => @patient }}
          
        else
          format.js
          format.html{ render :action => "new" }
          format.json { render :json => {"value" => "fail", "errors" => @patient.errors } }
        end
      end
    end
  end
  
  def edit
#    @patient = JSON.parse(Patient.find(params[:id]).to_json)
    @patient = Patient.find(params[:id])
    respond_to do |format|
      format.json{ render :json => { :success => "true", :user => @patient }}
      format.html{render :layout => 'new_admin'}
      format.js
    end
  end
  
  
#  def show
#    @patient = JSON.parse(Patient.find(params[:id]).to_json)
#    respond_to do |format|
#      format.json { render :json => { :success => "true", :user => JSON.parse(@patient.to_json) }}
#      format.html
#      format.js{}
#    end
#  end

  
  
  def update
    @patient = Patient.unscoped.find(params[:id])
    # params[:patient] = params[:patient].merge(:gender => request.env["rack.request.form_hash"]['action'])
    respond_to do |format|
      if @patient.update_attributes(patient_params)
        format.js {}
        format.html {redirect_to profile_patient_path(@patient), :notice => 'Patient was successfully created.', :layout => 'users'}
        format.json { render :json => { :success => "true", :user => @patient }}
      else
        format.js
        format.html{ render :action => "edit", :layout => 'new_admin' }
        format.json { render :json => {"value" => "fail", "errors" => @patient.errors } }
      end
    end
  end
  
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy
    redirect_to admin_users_path, :notice => 'Patient was successfully deleted.'
  end
  
  def update_user_status
    @patient = Patient.unscoped.find(params[:id])
    if params[:p]
      @patient.update_attribute(:status, params[:status])
    end
    redirect_to edit_admin_user_path(@patient)
  end
  
  
  def delete_profile_pic
    @patient = Patient.unscoped.find(params[:id]) rescue nil
    if params[:p]
      @patient.image = nil
      @patient.save(:validate => false)
    end
    redirect_to edit_admin_user_path(@patient)
  end
  
  
  def delete_profile
    @patient = Patient.unscoped.find(params[:id]) rescue nil
    if params[:p]
      @patient.destroy
    end
    redirect_to admin_users_path
  end

  def change_doctor_list
    # @doctors = Doctor.all
    @doctors = Doctor.where(:specialize => params[:specialize])# if params[:specialize].present?
    respond_to do |format|
      format.js{}
    end
  end
  
  protected 

  def patient_params
    params.require(:patient).permit!#(:name, :display_name, :launch_date, :image, :status)
  end

end
