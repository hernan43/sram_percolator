json.extract! save_file, :id, :name, :game_id, :notes, :created_at, :updated_at
json.url save_file_url(save_file, format: :json)
