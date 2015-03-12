class AddPrecisionAndSourceFile < ActiveRecord::Migration
  def change 
    add_column :locations, :location_type, :string
    add_column :locations, :source, :string
  end
end
