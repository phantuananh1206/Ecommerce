class User < ApplicationRecord
  has_one_attached :image
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy

  enum role: { admin: 0, member: 1, block: 2 }

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :email, length: { maximum: Settings.validation.email_max },
                      format: { with: Constant::VALID_EMAIL_REGEX }, uniqueness: true
    validates :password, length: { minimum: Settings.validation.password_min }
  end
  validates :phone_number, format: { with: Constant::VALID_PHONE_REGEX },
                           length: { minimum: Settings.validation.phone_min },
                           uniqueness: true, allow_nil: true

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
