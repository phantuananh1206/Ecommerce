class CategoriesController < ApplicationController
  before_action :load_category, only: %i(show)

  def show
    @products = @category.products.sort_name_alphabetically
                         .page(params[:page])
                         .per(Settings.quantity_per_page)
  end

  def load_category
    return if @category = Category.find_by(id: params[:id])

    flash[:danger] = t('category.category_not_found')
    redirect_to root_path
  end
end
