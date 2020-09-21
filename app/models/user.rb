class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable

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
end
