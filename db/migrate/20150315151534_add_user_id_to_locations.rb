class AddUserIdToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :user, index: true
    add_foreign_key :locations, :users
    add_index :locations, [:user_id, :created_at, :source]

  end
end
