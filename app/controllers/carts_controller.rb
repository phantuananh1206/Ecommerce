class CartsController < ApplicationController
  include CartsHelper

  before_action :current_cart, only: %i(index create)
  before_action :load_product, :check_quantity, only: %i(create)

  def index
    @products = Product.by_ids(@cart[:products].keys)
    @products_in_cart = []
    total = 0
    @cart[:products].each do |product_id, quantity|
      product = @products.find { |product| product.id == product_id.to_i }
      if product
        @products_in_cart << add_infor_product(product, quantity)
        total += product.price * quantity
      else
        session[:cart][:products].delete(product_id)
      end
    end
    session[:cart][:total] = total
  end

  def create
    if @cart[:products].include?(params[:product_id])
      @cart[:products][params[:product_id]] += params[:quantity].to_i
    else
      @cart[:products][params[:product_id]] = params[:quantity].to_i
    end
    @cart[:count] = count_items
    @cart[:total] += params[:price].to_f * params[:quantity].to_i
    session[:cart] = @cart
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:product_id])

    flash[:danger] = t('product.product_not_found')
    redirect_to carts_path
  end

  def quantity_valid
    params[:quantity].to_i <= @product.quantity &&
    params[:quantity].to_i >= Settings.product.min_quantity &&
    params[:quantity].to_i + @cart[:products][params[:product_id]].to_i <= @product.quantity
  end

  def check_quantity
    return if quantity_valid

    flash[:danger] = t('product.invalid_quantity')
    redirect_to root_path
  end

  def add_infor_product(product, quantity)
    { 'product_id': product.id, 'product_name': product.name, 'quantity': quantity,
      'price': product.price, 'category_name': product.category_name,
      'quantity_in_stock': product.quantity, 'subtotal': product.price * quantity }
  end
end
