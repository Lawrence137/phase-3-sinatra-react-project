require 'bcrypt'

class User < ActiveRecord::Base
  has_many :tasks

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  # The 'password' attribute is a virtual attribute used to store the plaintext password
  # entered by the user. The actual password is stored as a hash in the 'password_hash'
  # column.
  attr_accessor :password

  # This callback encrypts the plaintext password and stores it in the 'password_hash'
  # column.
  before_save do
    if password
      self.password_hash = BCrypt::Password.create(password)
    end
  end

  # This method authenticates a user by comparing the supplied plaintext password
  # with the encrypted password hash in the database.
  def authenticate(password)
    if BCrypt::Password.new(password_hash) == password
      self
    else
      false
    end
  end
end
