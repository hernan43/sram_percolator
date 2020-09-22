class CreateSaveFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :save_files do |t|
      t.string :name
      t.integer :game_id
      t.text :notes

      t.timestamps
    end
    add_index :save_files, :game_id
  end
end
