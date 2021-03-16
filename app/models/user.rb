class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

  has_one_attached :image
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy

  enum role: { admin: 0, member: 1, block: 2 }

  validates :name, presence: true,
                   length: { maximum: Settings.validation.name_max }
  validates :email, presence: true,
                    length: { maximum: Settings.validation.email_max },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :phone_number, format: { with: VALID_PHONE_REGEX },
                           length: { minimum: Settings.validation.phone_min },
                           uniqueness: true, allow_nil: true
  validates :password, presence: true,
                       length: { minimum: Settings.validation.password_min }

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
