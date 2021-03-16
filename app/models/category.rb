class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }

  scope :subcategories, -> { where.not(parent_id: nil) }
end