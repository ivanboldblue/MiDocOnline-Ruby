class ChargesController < ApplicationController
  before_action :load_filter, :only => [:new, :create]
  

  def new
    #if session[:charge_id].present? and session[:charge_amount].present?
    #  redirect_to video_chats_path(:specialize => params[:specialize])
    #else
      render :layout => false
    #end
  end

  def create
    # Amount in cents
    @amount = 7000
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    session[:charge_customer_id] = customer.id
    session[:reload_count] = 0

    # charge = Stripe::Charge.create(
    #   :customer    => customer.id,
    #   :amount      => @amount,
    #   :description => 'Video call charge',
    #   :currency    => 'mxn'
    # )

  if true#charge.present? and charge.status == 'succeeded'
    #session[:charge_id] = charge.id
    #session[:charge_amount] = @amount
    if params[:caller_id].present? and params[:specialize].present?
      redirect_to video_chats_path(:specialize => params[:specialize], :caller_id => params[:caller_id])
    elsif params[:caller_id].present?
      redirect_to video_chats_path(:caller_id => params[:caller_id])
    else
      redirect_to video_chats_path(:specialize => params[:specialize])
    end
  end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

end
