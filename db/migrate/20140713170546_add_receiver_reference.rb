class AddReceiverReference < ActiveRecord::Migration
  def up
    add_column :shipment_stores, :receiver_refer, :string
    add_index :shipment_stores, :receiver_refer
  end

  def down
    remove_column :shipment_stores, :receiver_refer, :string
    remove_index :shipment_stores, :receiver_refer
  end
end
