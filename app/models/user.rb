class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable

  before_create :set_api_key

  def account_active?
      return !self.is_disabled
  end

  def active_for_authentication?
    super && account_active?
  end

  def fullname
    return self.first_name if not self.first_name.blank? and self.last_name.blank?
    return self.last_name if not self.last_name.blank? and self.first_name.blank?

    return "#{self.first_name} #{self.last_name}" if not self.first_name.blank? and not self.last_name.blank?

    return self.email
  end

  def has_name?
    self.fullname != self.email
  end

  def set_api_key
    self.api_key = self.generate_api_key
  end

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

end
