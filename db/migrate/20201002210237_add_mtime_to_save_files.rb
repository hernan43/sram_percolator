class AddMtimeToSaveFiles < ActiveRecord::Migration[6.0]
  def change
    add_column :save_files, :mtime, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
