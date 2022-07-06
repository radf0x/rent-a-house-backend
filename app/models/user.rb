class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :likes, dependent: :destroy
  has_many :properties, class_name: 'Property', through: :likes

  enum role: %i[user admin]

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :name, presence: true
  validates :password, presence: true
  validates :role, inclusion: { in: roles.keys, message: "role must be one of #{roles.keys}" }

  # Override devise.authenticate to simplify the usage
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
