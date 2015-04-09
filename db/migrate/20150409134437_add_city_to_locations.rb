class AddCityToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :city, :string, after: :address
    add_column :locations, :state, :string, after: :city
    add_column :locations, :zip, :string, after: :state
  end
end
