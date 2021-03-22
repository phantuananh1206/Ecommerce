module ApplicationHelper
  def full_title(page_title = '')
    base_title = t('logo')
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def pending_reconfirmation?
    resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email
  end

  def load_image_product(product)
    image_tag(product.images.attached? ? product.images : 'macbook_pro.jpg')
  end

  def count_items
    @count_items = session[:cart][:count] if session[:cart]
  end
  
  def subtotal price, quantity
    price * quantity
  end
end
