require 'bcrypt'

class User < ActiveRecord::Base
  has_many :tasks

  # retrieve password from hash
  def password
    @password ||= Password.new(password_hash)
  end

  # create the password hash
  def password=(new_pass)
    @password = BCrypt::Password.create(new_pass)
    self.password_hash = @password
  end
end
