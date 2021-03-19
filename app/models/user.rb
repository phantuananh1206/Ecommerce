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
    @user = find_by(email: auth.info.email)
    if @user
      @user.assign_attributes(provider: auth.provider, uid: auth.uid,
                              image: auth.info.image)
      return @user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider
        user.skip_confirmation!
      end
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
