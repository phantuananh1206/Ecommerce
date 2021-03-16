class Store < ApplicationRecord
  has_many :products, dependent: :destroy

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :address
  end
end
