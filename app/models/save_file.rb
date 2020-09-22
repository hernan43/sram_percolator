class SaveFile < ApplicationRecord
  belongs_to :game
  has_one_attached :sram
end
