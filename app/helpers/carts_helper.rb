module CartsHelper
  def current_cart
    session[:cart] ||= { products: {}, count: 0, total: 0 }
    @cart = session[:cart]
  end

  def count_items
    @count_items = session[:cart][:products].size if session[:cart]
  end
end
