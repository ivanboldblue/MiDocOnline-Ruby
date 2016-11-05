class ChatsController < ApplicationController
  
  before_action :load_filter

  # before_action :authenticate_admin
  # layout 'new_admin'
  layout 'users'

  
  def index
  end

  def show
    @history = History.find(params[:id])
    @chats = @history.chats
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user_id = current_user.id
    if @chat.save
      redirect_to show_chat_history_path(:id => @chat.history_id)
    else
      render 'show'
    end
  end

  def edit
  end
  
  def destroy
  end
  

  protected 

  def chat_params
    params.require(:chat).permit!#(:name, :display_name, :launch_date, :image, :status)
  end
  

end
