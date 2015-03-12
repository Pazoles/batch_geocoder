class AddExternalIdToLocations < ActiveRecord::Migration
  def change
        add_column :locations, :externalid, :string

  end
end
