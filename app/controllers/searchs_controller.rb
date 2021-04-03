class SearchsController < ApplicationController
  def index
    @products = @q.result.page(params[:page])
                         .per(Settings.quantity_per_page)
  end
end
