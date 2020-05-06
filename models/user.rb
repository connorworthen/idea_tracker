class User < ActiveRecord::Base
  has_many :lists
  has_secure_password
  has_many :ideas, through: :lists
end