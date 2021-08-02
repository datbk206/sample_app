class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.name.max_length}

  validates :email, presence: true,
            length: {maximum: Settings.email.max_length},
            format: {with: Settings.email.valid_regex},
            uniqueness: {case_sensitive: false}

  validates :password, presence: true,
            length: {minimum: Settings.password.min_length}
  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
