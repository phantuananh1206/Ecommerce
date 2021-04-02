class Order < ApplicationRecord
  belongs_to :user
  belongs_to :voucher, optional: true
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  enum status: { waiting: 0, confirmed: 1, accepted: 2, refused: 3,
                 canceled: 4, shipping: 5, delivered: 6 }

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :phone_number, format: { with: Constant::VALID_PHONE_REGEX }
    validates :address
    validates :delivery_time
  end

  after_create :update_quantity_of_product, :update_usage_limit_voucher

  private

  def update_quantity_of_product
    order_details.each do |order_detail|
      order_detail.update_quantity_product
    end
  end

  def update_usage_limit_voucher
    return unless voucher

    voucher.update(usage_limit: voucher.usage_limit - 1)
  end
end
