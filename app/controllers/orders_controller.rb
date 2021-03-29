class OrdersController < ApplicationController
  include CartsHelper
  include OrdersHelper

  before_action :store_location, :authenticate_user!
  before_action :current_cart, :load_product_from_cart
  before_action :current_voucher, only: %i(apply_voucher cancel_voucher)
  before_action :load_voucher, only: %i(apply_voucher)
  before_action :load_user, only: %i(create)

  def new; end

  def create
    @order = current_user.orders.new(order_params)
    if current_voucher.blank? || valid_voucher?
      ActiveRecord::Base.transaction do
        save_ordered_products
        @order.save!
      end
      save_success
    else
      session.delete(:voucher)
      flash[:danger] = t('order.voucher_not_valid')
      redirect_to new_order_path
    end
  rescue
    flash[:danger] = t('order.create_failed')
    redirect_to new_order_path
  end

  def apply_voucher
    if @voucher.order_valid_voucher(@cart[:total])
      session[:voucher] = @voucher
    else
      session.delete(:voucher)
      flash[:danger] = t('order.voucher_not_valid')
      redirect_to new_order_path
    end
  end

  def cancel_voucher
    if session[:voucher]
      session.delete(:voucher)
    else
      flash[:danger] = t('order.delete_voucher_failed')
      redirect_to new_order_path
    end
  end

  private

  def load_product_from_cart
    if @cart[:products].empty?
      flash[:danger] = t('cart.cart_is_empty')
      redirect_to root_path
    else
      @products = Product.by_ids(@cart[:products].keys)
      @order = current_user.orders.new
      @order_details = []
      total = 0
      @cart[:products].each do |product_id, quantity|
        product = @products.find { |product| product.id == product_id.to_i }
        if product && valid_quantity(product, quantity)
          @order_details << add_infor_product(product, quantity)
          total += product.price * quantity
        else
          session[:cart][:products].delete(product_id)
          flash[:danger] = t('order.product_not_found')
          redirect_to(new_order_path) and return
        end
      end
      session[:cart][:total] = total
    end
  end

  def valid_voucher?
    return unless current_voucher

    Voucher.find_by(id: current_voucher[:id])&.order_valid_voucher(@cart[:total])
  end

  def load_voucher
    @code = params[:voucher]
    return if @voucher = Voucher.find_by(code: @code)

    session.delete(:voucher)
    flash[:danger] = t('order.voucher_not_found')
    redirect_to new_order_path
  end

  def order_params
    params.require(:order).permit(:name, :phone_number, :address, :delivery_time)
                          .merge(total: total_after_discount, voucher_id: current_voucher[:id])
  end

  def save_ordered_products
    @products = Product.by_ids(@cart[:products].keys)
    @cart[:products].each do |product_id, quantity|
      product = @products.find { |product| product.id == product_id.to_i }
      if product && valid_quantity(product, quantity)
        @order.order_details.new(product_id: product.id,
                                 quantity: quantity,
                                 price: product.price)
      else
        session[:cart][:products].delete(product_id)
        flash[:danger] = t('order.product_not_found')
        redirect_to(new_order_path) and return
      end
    end
  end

  def add_infor_product(product, quantity)
    { product_id: product.id, product_name: product.name, quantity: quantity,
      price: product.price, subtotal: product.price * quantity }
  end

  def valid_quantity(product, quantity)
    quantity.to_i <= product.quantity &&
      quantity.to_i >= Settings.product.min_quantity
  end

  def save_success
    OrderMailer.confirmation_order(@order, @user).deliver_now
    session.delete(:cart)
    session.delete(:voucher)
    flash[:info] = t('order.confirm_order')
    redirect_to root_path
  end

  def load_user
    return if @user = User.find_by(email: current_user[:email])

    flash[:danger] = t('order.user_not_found')
    redirect_to root_path
  end
end
