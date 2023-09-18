class CreateShipmentStores < ActiveRecord::Migration
  def change
    create_table :shipment_stores do |t|
      t.string :order_id
      t.belongs_to :user
      t.string :awb
      t.string :label_url
      t.string :order_number

      t.timestamps
    end
    add_index :shipment_stores, :order_id, unique: true
    add_index :shipment_stores, :user_id
    add_index :shipment_stores, :awb, unique: true
    add_index :shipment_stores, :order_number
  end
end
