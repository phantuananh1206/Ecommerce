class Voucher < ApplicationRecord
  has_many :orders

  with_options presence: true do
    validates :code, length: { maximum: Settings.validation.code_max }, uniqueness: true
    validates :discount
    validates :condition
    validates :expiry_date
    validates :usage_limit, numericality: { only_integer: true,
                                            greater_than_or_equal_to: Settings.validation.number.zero }
  end

  def order_valid_voucher(order_total)
    order_total >= condition &&
      expiry_date >= Time.zone.now &&
      usage_limit >= 1
  end
end
