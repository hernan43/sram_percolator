class Game < ApplicationRecord
  belongs_to :user
  has_many :save_files, dependant: :destroy

  acts_as_taggable_on :platforms
end
