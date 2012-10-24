class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string  :favoriter_type
      t.integer :favoriter_id
      t.string  :favoritable_type
      t.integer :favoritable_id
      t.datetime :created_at
    end

    add_index :favorites, ["favoriter_id", "favoriter_type"],       :name => "fk_favorites"
    add_index :favorites, ["favoritable_id", "favoritable_type"], :name => "fk_favoritables"
  end
end
