class OrderConfirmationsController < ApplicationController
  before_action :authenticate_user!, :load_order, :check_expiration

  def edit
    if @order.may_confirm?
      @order.confirm!
      flash[:success] = t('order.confirm_successful')
    else
      flash[:danger] = t('order.confirm_failed')
      redirect_to root_path
    end
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id], user_id: current_user[:id])

    flash[:danger] = t('order.order_not_found')
    redirect_to root_path
  end

  def check_expiration
    return unless @order.confirm_order_expired?

    flash[:danger] = t('order.confirm_expired')
    redirect_to root_path
  end
end
