class SaveFileSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes

  belongs_to :game
end
