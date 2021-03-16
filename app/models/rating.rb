class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :point, presence: true,
            numericality: { only_integer: true,
                            greater_than: Settings.validation.number.zero,
                            less_than: Settings.validation.number.six }
end
