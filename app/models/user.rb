class User < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :save_files, through: :games

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

  def generate_api_key
    loop do
      token = SecureRandom.hex(20)
      break token unless User.exists?(api_key: token)
    end
  end

  def set_api_key
    self.api_key = self.generate_api_key
  end

  def platforms
    tag_ids = ActsAsTaggableOn::Tagging.where(taggable_type: 'Game', taggable_id: self.games).pluck(:tag_id)
    ActsAsTaggableOn::Tag.where(id: tag_ids).order(:name)
  end

end
