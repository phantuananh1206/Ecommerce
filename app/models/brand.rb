class Brand < ApplicationRecord
  has_many :products, dependent: :destroy

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :origin, length: { maximum: Settings.validation.origin_max }
  end
end
