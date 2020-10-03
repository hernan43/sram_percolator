class SaveFile < ApplicationRecord
  belongs_to :game
  has_one_attached :sram

  def full_name
    if not name.blank?
      name
    end
  end
end
