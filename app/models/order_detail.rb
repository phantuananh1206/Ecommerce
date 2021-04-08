class OrderDetail < ApplicationRecord
  belongs_to :product
  belongs_to :order

  with_options presence: true do
    validates :quantity, numericality: { only_integer: true, greater_than: Settings.validation.number.zero }
    validates :price, numericality: { greater_than: Settings.validation.number.zero }
  end

  delegate :quantity, :name, to: :product, prefix: true

  def subtotal
    price * quantity
  end

  def update_quantity_product
    product.update(quantity: (product.quantity - quantity))
  end

  def restock_product
    product.update(quantity: (product.quantity + quantity))
  end
end
