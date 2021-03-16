class Voucher < ApplicationRecord
  has_many :orders, dependent: :destroy

  with_options presence: true do
    validates :code, length: { maximum: Settings.validation.code_max }, uniqueness: true
    validates :discount
    validates :condition
    validates :expiry_date
    validates :usage_limit, numericality: { only_integer: true,
                                            greater_than_or_equal_to: Settings.validation.number.zero }
  end
end
