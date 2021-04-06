class Admin::OrdersController < Admin::BaseController
  before_action :load_order, only: %i(update)

  def index
    @orders = Order.sort_order_by_created_at
                   .page(params[:page])
                   .per(Settings.quantity_per_page)
  end

  def update
    update_status_order
    redirect_to admin_orders_path
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:danger] = t('order.order_not_found')
    redirect_to root_path
  end

  def update_status_order
    case params[:status].to_i
    when Order.statuses[:accepted]
      @order.accept!
    when Order.statuses[:refused]
      @order.refuse
    when Order.statuses[:shipping]
      @order.ship!
    when Order.statuses[:delivered]
      @order.delivered!
    else
      flash[:danger] = t('order.update_status_order_failed')
    end
  end
end
