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

  def load_link_to_status_order(order)
    link_to("#{order.aasm.events(reject: :refuse).map(&:name).join("', '")}",
      admin_order_path(id: order.id, status: "#{order.aasm.events(reject: :refuse).map(&:name).join("', '")}"),
                       method: :patch, remote: true, class: 'btn btn-success btn-md')
  end

  def load_link_to_refuse_order(order)
    if order.aasm.current_state == :confirmed
      link_to("#{order.aasm.events(reject: :accept).map(&:name).join("', '")}",
        admin_order_path(id: order.id, status: "#{order.aasm.events(reject: :accept).map(&:name).join("', '")}"),
                         method: :patch, remote: true, class: 'btn btn-danger btn-md')
    end
  end
end
