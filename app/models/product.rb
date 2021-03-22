class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many_attached :images
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :orders, through: :order_details

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :quantity, numericality: { only_integer: true,
                                         greater_than_or_equal_to: Settings.validation.number.zero }
    validates :price, numericality: { greater_than: Settings.validation.number.zero }
  end

  scope :sort_name_alphabetically, -> { order(name: :asc) }
end
