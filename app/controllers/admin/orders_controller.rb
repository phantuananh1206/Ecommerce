class Admin::OrdersController < Admin::BaseController
  before_action :load_order, only: %i(show update)

  def index
    @orders = Order._created_at_desc
                   .page(params[:page])
                   .per(Settings.quantity_per_page)
  end

  def show
    @order_details = @order.order_details
  end

  def update
    update_status_order
  end

  private

  def load_order
    return if @order = Order.find_by(id: params[:id])

    flash[:danger] = t('admin.order.order_not_found')
    redirect_to root_path
  end

  def update_status_order
    begin
      @order.send("#{params[:status]}!")
      flash[:success] = t('admin.order.update_status_success')
    rescue
      flash[:danger] = t('admin.order.update_status_order_failed')
    end
    redirect_to admin_orders_path
  end
end
