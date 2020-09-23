class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :platforms

  belongs_to :user
  has_many :save_files

  def platforms
    self.object.platforms.map do |p|
      {
        id: p.id,
        name: p.name, 
        taggings: p.taggings.count
      }
    end
  end
end
