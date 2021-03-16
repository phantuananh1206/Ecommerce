class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand

  has_one_attached :image
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :orders, through: :order_details

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }
  validates :quantity, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to:
                                       Settings.validation.number.zero }
  validates :price, presence: true,
                    numericality: { greater_than:
                                    Settings.validation.number.zero }
end
