class User < ApplicationRecord
  validates_presence_of :login, :password_digest
  validates_uniqueness_of :login

  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :ips, dependent: :destroy
  has_many :feedbacks, as: :owner
end
