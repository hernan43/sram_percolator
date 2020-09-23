class SaveFileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :notes, :sram

  belongs_to :game

  def sram
    if not self.object.sram.attachment.nil?
      {
        filename: self.object.sram.filename,
        path: rails_blob_path(self.object.sram, only_path: true)
      }
    end
  end
end
