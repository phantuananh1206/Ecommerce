class StaticPagesController < ApplicationController
  def home
    @products = Product.sort_name_alphabetically
                       .page(params[:page])
                       .per(Settings.quantity_per_page)
  end
end
