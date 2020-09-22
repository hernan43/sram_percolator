class GameSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :user
  has_many :save_files
end
