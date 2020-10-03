class SaveFileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :mtime, :mtime_seconds, :name, :notes, :sram

  belongs_to :game

  def mtime_seconds
    self.object.mtime.to_i
  end

  def sram
    if not self.object.sram.attachment.nil?
      {
        filename: self.object.sram.filename,
        path: rails_blob_path(self.object.sram, only_path: true),
        checksum: self.object.sram.checksum
      }
    end
  end
end
