class OrderDetail < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true,
                       numericality: { only_integer: true,
                                       greater_than: Settings.validation.number.zero }
  validates :price, presence: true,
                    numericality: { greater_than: Settings.validation.number.zero }
end
