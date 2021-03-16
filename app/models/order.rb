class Order < ApplicationRecord
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

  belongs_to :user
  belongs_to :voucher, optional: true

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  enum status: { waiting: 0, confirmed: 1, accepted: 2, refused: 3,
                canceled: 4, shipping: 5, delivered: 6 }

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }
  validates :phone_number, presence: true,
                           format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true
  validates :delivery_time, presence: true
end
