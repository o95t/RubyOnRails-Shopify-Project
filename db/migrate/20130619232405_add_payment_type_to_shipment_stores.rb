class AddPaymentTypeToShipmentStores < ActiveRecord::Migration
  def change
    add_column :shipment_stores, :payment_type, :string
    add_index :shipment_stores, :payment_type
  end
end
