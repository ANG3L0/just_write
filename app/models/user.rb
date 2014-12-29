class User < ActiveRecord::Base
	has_many :articles
  attr_accessor :remember_token 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :score_in, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :score_out, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 100 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  #allow_blank true is ok since has_secure_password validates on object creation
  #only other time password touched is changing passwords (ok), and changing emails
  #where changing emails interprets password as < 6 length since we don't .require it
  #allow_blank works around this issue
  validates :password, length: { minimum: 6 }, allow_blank: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost 
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

	def User.voting_power(user)
		user.score_in/user.score_out
	end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end
