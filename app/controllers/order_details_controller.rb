class OrderDetailsController < ApplicationController
  before_action :load_order

  def index
    @order_details = @order.order_details
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:order_id])

    flash[:danger] = t('order.order_not_found')
    redirect_to root_path
  end
end
