class OrderConfirmationsController < ApplicationController
  before_action :load_order, :check_expiration

  def edit
    if @order.waiting?
      @order.confirmed!
      flash[:success] = t('order.confirm_successful')
    else
      flash[:danger] = t('order.confirm_failed')
      redirect_to root_path
    end
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:danger] = t('order.order_not_found')
    redirect_to root_path
  end

  def check_expiration
    return unless @order.confirm_order_expired?

    flash[:danger] = t('order.confirm_expired')
    redirect_to root_path
  end
end
