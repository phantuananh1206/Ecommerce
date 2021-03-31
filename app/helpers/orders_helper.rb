module OrdersHelper
  def current_voucher
    session[:voucher] ||= {}
  end

  def total_price_order
    total = @cart[:total]
    if session[:voucher]
      total -= session[:voucher][:discount].to_f
    else
      total
    end
  end
end
