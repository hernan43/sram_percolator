class SaveFileSerializer < ActiveModel::Serializer
  attributes :id, :name, :game_id, :notes
end
