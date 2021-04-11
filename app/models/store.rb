class Store < ApplicationRecord
  has_many :products, dependent: :destroy

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :address
  end

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
