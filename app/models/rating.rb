class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :point, presence: true,
                    numericality: { only_integer: true,
                                    greater_than: Settings.validation.min_point,
                                    less_than: Settings.validation.max_point }
end
