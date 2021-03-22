class CartsController < ApplicationController
  before_action :current_cart, only: %i(index create)
  before_action :load_product, :check_quantity, only: %i(create)

  def index
    @order_details = Array.new
    @cart[:product].each do |product_id, quantity|
      @product = Product.find_by(id: product_id)
      @order_details << OrderDetail.new(product_id: @product.id, quantity: quantity,
                                        price: @product.price)
    end
  end

  def create
    if @cart[:product].include?(params[:product_id])
      @cart[:product][params[:product_id]] += params[:quantity].to_i
    else
      @cart[:product][params[:product_id]] = params[:quantity].to_i
      @cart[:count] += 1
    end
    @cart[:total] += params[:price].to_f * params[:quantity].to_i
    session[:cart] = @cart
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:product_id])

    flash[:danger] = t('product.product_not_found')
    redirect_to carts_path
  end

  def check_quantity
    return if params[:quantity].to_i <= @product.quantity &&
              params[:quantity].to_i >= Settings.product.min_quantity &&
              params[:quantity].to_i + @cart[:product][params[:product_id]].to_i <= @product.quantity

    flash[:danger] = t('product.invalid_quantity')
    redirect_to root_path
  end
end
