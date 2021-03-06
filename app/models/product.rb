class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many_attached :images
  has_many :order_details, dependent: :restrict_with_error
  has_many :ratings, dependent: :restrict_with_error
  has_many :orders, through: :order_details

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :quantity, numericality: { only_integer: true,
                                         greater_than_or_equal_to: Settings.validation.number.zero }
    validates :price, numericality: { greater_than: Settings.validation.number.zero }
  end

  scope :sort_name_alphabetically, -> { order(name: :asc) }
  scope :by_ids, ->(ids) { where(id: ids) }

  delegate :name, to: :category, prefix: true

  def avg_point
    if ratings.present?
      ratings.average(:point).round(1).to_f
    else
      0.0
    end
  end

  def point_percentage
    if ratings.present?
      ratings.average(:point).round(1).to_f * 90 / 5
    else
      0.0
    end
  end
end
