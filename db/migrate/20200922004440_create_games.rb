class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :platform
      t.integer :user_id

      t.timestamps
    end
    add_index :games, :platform
    add_index :games, :user_id
  end
end
