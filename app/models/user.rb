class User < ApplicationRecord
  validates_presence_of :login, :password_digest
  validates_uniqueness_of :login

  has_secure_password
  has_many: Post
end
