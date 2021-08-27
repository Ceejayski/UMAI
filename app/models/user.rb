class User < ApplicationRecord
  validates_presence_of :login, :password_digest
  validates_uniqueness_of :login
end
