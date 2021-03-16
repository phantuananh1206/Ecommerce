class Store < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }
  validates :address, presence: true
end
