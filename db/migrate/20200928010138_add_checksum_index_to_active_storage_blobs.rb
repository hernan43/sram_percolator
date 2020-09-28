class AddChecksumIndexToActiveStorageBlobs < ActiveRecord::Migration[6.0]
  def change
    add_index :active_storage_blobs, :checksum
  end
end
