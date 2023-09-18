class AddReference1ToPickupStores < ActiveRecord::Migration
  def change
    add_column :pickup_stores, :reference1, :string
    add_index :pickup_stores, :reference1
  end
end
