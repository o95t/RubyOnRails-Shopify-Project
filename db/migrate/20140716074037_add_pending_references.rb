class AddPendingReferences < ActiveRecord::Migration
  def up
    add_column :shipment_stores, :shipper_refer, :string
    add_column :shipments, :shipment_refer, :string
    add_column :shipments, :shipper_refer, :string

    add_index :shipment_stores, :shipper_refer
    add_index :shipments, :shipment_refer
    add_index :shipments, :shipper_refer

  end

  def down

    remove_column :shipment_stores, :shipper_refer, :string
    remove_column :shipments, :shipment_refer, :string
    remove_column :shipments, :shipper_refer, :string

    remove_index :shipment_stores, :shipper_refer
    remove_index :shipments, :shipment_refer
    remove_index :shipments, :shipper_refer

  end
end
