class AddReferenceToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :receiver_refer, :string
    add_index :shipments, :receiver_refer
  end
end
