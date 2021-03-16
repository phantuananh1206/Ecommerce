class Brand < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }
  validates :origin, presence: true,
                     length: { maximum: Settings.validation.origin_max }
end
