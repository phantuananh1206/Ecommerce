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

  def ransack_product
    Product.ransack(params[:q])
  end

  def link_to_next_order_state(order)
    event_name = order.aasm.events(reject: :refuse).map(&:name).first
    return if event_name.blank?

    text = t(event_name, scope: 'admin.order.status')
    options = { method: :patch, remote: :true, class: 'btn btn-success btn-md' }
    link_to(text, admin_order_path(id: order.id, status: event_name), options)
  end
end
