class HistoriesController < ApplicationController
  
  before_action :load_filter

  before_action :authenticate_admin
  layout 'new_admin'

  
  def index
  end

  def show
  end

  def edit
  end
  
  def destroy
  end
  

  def update_paid_history
    @history = History.find(params[:id])
    @history.update_attributes(:paid_to_doctor => params[:paid_to_doctor], :paid_date => Time.now)
    redirect_to :back, :notice => 'history was successfully updated.'
  end

  protected 

  def history_params
    params.require(:history).permit!#(:name, :display_name, :launch_date, :image, :status)
  end
  

end
