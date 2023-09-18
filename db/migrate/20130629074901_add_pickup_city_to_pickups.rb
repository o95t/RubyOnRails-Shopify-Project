class AddPickupCityToPickups < ActiveRecord::Migration
  def change
    add_column :pickups, :pickup_city, :string
  end
end
