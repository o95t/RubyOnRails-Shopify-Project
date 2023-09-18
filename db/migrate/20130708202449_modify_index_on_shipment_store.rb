class ModifyIndexOnShipmentStore < ActiveRecord::Migration
  def change
  	remove_index :shipment_stores, :order_id
  	add_index :shipment_stores, :order_id
  end
end
