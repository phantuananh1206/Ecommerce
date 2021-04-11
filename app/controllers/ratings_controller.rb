class RatingsController < ApplicationController
  before_action :store_location, :authenticate_user!, only: :create
  before_action :load_product, only: :index

  def index
    @ratings = @product.ratings
  end

  def create
    @rating = current_user.ratings.new(rating_params)
    if @rating.save
      flash[:success] = t('rating.rating_success')
      redirect_to product_ratings_path
    else
      flash[:danger] = t('rating.rating_failed')
      redirect_to product_path(params[:product_id])
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:product_id, :content, :point)
  end

  def load_product
    return if @product = Product.find_by(id: params[:product_id])

    flash[:danger] = t('product.product_not_found')
    redirect_to root_path
  end
end
