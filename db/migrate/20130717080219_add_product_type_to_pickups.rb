class AddProductTypeToPickups < ActiveRecord::Migration
  def change
    add_column :pickups, :product_type, :string
  end
end
