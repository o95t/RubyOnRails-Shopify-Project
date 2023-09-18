class AddShipperPhoneNumberToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :shipper_phone_number, :string
    add_column :shipments, :shipper_tax_id_vat, :string
    add_column :shipments, :shipper_state, :string
    
    add_column :shipments, :receiver_phone_number, :string
    add_column :shipments, :receiver_tax_id_vat, :string
    add_column :shipments, :receiver_state, :string
  end
end
