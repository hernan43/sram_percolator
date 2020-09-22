class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :platform, :user_id
end
