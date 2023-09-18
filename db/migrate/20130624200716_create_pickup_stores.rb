class CreatePickupStores < ActiveRecord::Migration
  def change
    create_table :pickup_stores do |t|
      t.belongs_to :user
      t.string :aramex_id
      t.string :guid
      t.string :product_group
      t.datetime :pickup_datetime

      t.timestamps
    end
    add_index :pickup_stores, :user_id
    add_index :pickup_stores, :guid
    add_index :pickup_stores, :product_group
  end
end
