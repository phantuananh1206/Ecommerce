class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many_attached :images
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy

  enum role: { admin: 0, member: 1, block: 2 }

  with_options presence: true do
    validates :name, length: { maximum: Settings.validation.name_max }
    validates :email, length: { maximum: Settings.validation.email_max },
                      format: { with: Constant::VALID_EMAIL_REGEX }, uniqueness: true
  end
  validates :phone_number, format: { with: Constant::VALID_PHONE_REGEX },
                           length: { minimum: Settings.validation.phone_min },
                           uniqueness: true, allow_nil: true

  before_save :downcase_email

  def self.from_omniauth(auth)
    user_with_provider = find_by(provider: auth.provider, uid: auth.uid)
    return user_with_provider if user_with_provider

    user = find_or_initialize_by(email: auth.info.email)
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.skip_confirmation!
    end
    user.uid = auth.uid
    user.provider = auth.provider
    user.save
    user
  end

  private

  def downcase_email
    email.downcase!
  end
end
