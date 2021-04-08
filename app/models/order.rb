class Order < ApplicationRecord
  include AASM

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

  aasm column: :status, enum: true do
    state :waiting, initial: true
    state :confirmed, :accepted, :refused,
          :canceled, :shipping, :delivered

    event :confirm do
      transitions from: :waiting, to: :confirmed
    end

    event :accept do
      transitions from: :confirmed, to: :accepted
    end

    event :refuse do
      transitions from: :confirmed, to: :refused, after: :restock_quantity_of_product
    end

    event :cancel do
      transitions from: :waiting, to: :canceled
    end

    event :ship do
      transitions from: :accepted, to: :shipping
    end

    event :delivered do
      transitions from: :shipping, to: :delivered
    end
  end

  scope :_created_at_desc, -> { order(created_at: :desc) }

  def total_price
    order_details.reduce(0) do |sum, od_detail|
      if od_detail.valid?
        sum + (od_detail.quantity * od_detail.price)
      else
        sum
      end
    end
  end

  def confirm_order_expired?
    created_at < Settings.mailer.confirm_order_expired.hours.ago
  end

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

  def restock_quantity_of_product
    order_details.each do |order_detail|
      order_detail.restock_product
    end
  end
end
