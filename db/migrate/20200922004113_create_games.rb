class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :platform

      t.timestamps
    end
    add_index :games, :platform
  end
end
