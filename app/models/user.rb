class User < ApplicationRecord
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  before_save {email.try(:downcase)}
  has_secure_password

  def self.from_omniauth(response)

    User.find_or_create_by(uid: response[:uid]) do |u|
      u.username = response[:info][:name]
      u.email = response[:info][:email]
      u.password = SecureRandom.hex(15)
    end
  end
end
