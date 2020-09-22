class Game < ApplicationRecord
  belongs_to :user
  has_many :save_files, dependent: :destroy

  acts_as_taggable_on :platforms
end
