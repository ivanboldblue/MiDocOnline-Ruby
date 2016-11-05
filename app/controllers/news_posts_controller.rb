class NewsPostsController < ApplicationController
	before_action :load_filter
#  skip_before_action :verify_authenticity_token
  before_action :authenticate_admin

  layout 'new_admin'

  def index
    @news_posts = NewsPost.unscoped.order("created_at desc")
    respond_to do |format|
      format.html {}
      #format.xls do
       # @news_posts = NewsPost.all
        #only_columns = [:id, :user_id, :description, :challenge_id]
        #method_allowed = [:suggested_user_name, :suggested_user_email, :suggested_date, :suggested_status, :challenge_name]
        #send_data @news_posts.to_xls(:only => only_columns, :methods => method_allowed)
      #end
    end
  end
  
  
  def new
    @news_post = NewsPost.new
  end

  def show
    @news_post = NewsPost.find(params[:id])
  end

  def profile
    @user = current_user
    if @user.blank?
      redirect_to root_path
    end
  end
  
  
  def create
    if params[:news_post].present?
      @news_post = NewsPost.new(news_post_params)
      respond_to do |format|
        if @news_post.save
          format.js {}
          format.html {redirect_to news_posts_path, :notice => 'NewsPost was successfully created.'}
          format.json { render :json => { :success => "true", :user => @news_post }}
          
        else
          format.js
          format.html{ render :action => "new" }
          format.json { render :json => {"value" => "fail", "errors" => @news_post.errors } }
        end
      end
    end
  end
  
  def edit
    @news_post = NewsPost.find(params[:id])
  end
  
  
#  def show
#    @news_post = JSON.parse(NewsPost.find(params[:id]).to_json)
#    respond_to do |format|
#      format.json { render :json => { :success => "true", :user => JSON.parse(@news_post.to_json) }}
#      format.html
#      format.js{}
#    end
#  end

  
  
  def update
    @news_post = NewsPost.unscoped.find(params[:id])
    respond_to do |format|
      if @news_post.update_attributes(news_post_params)
#        @news_post = JSON.parse(@news_post.to_json)
        format.js {}
        format.html {redirect_to news_posts_path, :notice => 'NewsPost was successfully created.'}
#        format.html {render :action => 'show'}
        format.json { render :json => { :success => "true", :user => @news_post }}
      else
        format.js
        format.html{ render :action => "edit", :layout => 'new_admin' }
        format.json { render :json => {"value" => "fail", "errors" => @news_post.errors } }
      end
    end
  end
  
  def destroy
    @news_post = NewsPost.find(params[:id])
    @news_post.destroy
    redirect_to admin_users_path, :notice => 'NewsPost was successfully deleted.'
  end
  
  def update_user_status
    @news_post = NewsPost.unscoped.find(params[:id])
    if params[:p]
      @news_post.update_attribute(:status, params[:status])
    end
    redirect_to edit_admin_user_path(@news_post)
#    render :text => "success"
  end
  
  protected 

  def news_post_params
    params.require(:news_post).permit!#(:name, :display_name, :launch_date, :image, :status)
  end

end
