class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)

  def show
    @rating = Rating.new
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:id])

    flash[:danger] = t('product.product_not_found')
    redirect_to root_path
  end
end
