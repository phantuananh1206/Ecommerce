class Admin::OrdersController < Admin::BaseController
  before_action :load_order, only: :update

  def index
    @orders = Order._created_at_desc
                   .page(params[:page])
                   .per(Settings.quantity_per_page)
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
    if Order.aasm.events.map(&:name).include?("#{params[:status]}".to_sym)
      if @order.send("may_#{params[:status]}?")
        @order.send("#{params[:status]}!")
        flash[:success] = t('admin.order.update_status_success')
      else
        flash[:danger] = t('admin.order.update_status_order_failed')
      end
    else
      flash[:danger] = t('admin.order.status_not_found')
    end
    redirect_to admin_orders_path
  end
end
