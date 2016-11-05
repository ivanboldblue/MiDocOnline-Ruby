class ContactsController < ApplicationController

	#before_action :load_filter
#  skip_before_action :verify_authenticity_token
  before_action :authenticate_admin, :except => [:new, :create]

  layout 'new_admin'

  
  def index
    @contacts = Contact.order("created_at desc")
    @contacts = @contacts.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.js {}
      format.html
      format.json { render status:200, :json=>{:status=>"Success",:contacts=> JSON.parse(@contacts.to_json)}}
    end
  end
  
  def new
    @contact = Contact.new
    render :layout => 'users'
  end
  
  
  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.js {}
        format.html {redirect_to new_contact_path, :notice => 'Thank you for contacting us.'}
        #format.html {redirect_to root_path, :notice => 'Thank you for contacting us.'}
      else
        format.js
        format.html{ render :action => "new", :layout => 'users' }
      end
    end
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def show
    @contact = JSON.parse(contact.find(params[:id]))
    respond_to do |format|
      format.json { render :json => { :success => "true", :contact => {:id => @contact.id, :caption => @contact.caption, :user_id => @contact.user_id, :challenge_id => @contact.challenge_id, :status => @contact.status, :image_url => @contact.image.url(:small)} }}
      format.html
      format.js{}
    end
  end
  
  def update
    @contact = Contact.unscoped.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(contact_params)
        format.js {}
        format.html {redirect_to contacts_path, :notice => 'contact was successfully created.'}
      else
        format.js
        format.html{ render :action => "edit" }
      end
    end
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_path, :notice => 'contact was successfully deleted.'
  end

  protected 

  def contact_params
    params.require(:contact).permit!#(:name, :display_name, :launch_date, :image, :status)
  end

end
