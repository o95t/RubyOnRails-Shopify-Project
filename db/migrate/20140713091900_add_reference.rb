class AddReference < ActiveRecord::Migration
  def up
    add_column :users, :user_refer, :string
    add_column :shipment_stores, :shipment_refer, :string
    add_index :users, :user_refer
    add_index :shipment_stores, :shipment_refer
  end

  def down
    remove_column :users, :user_refer, :string
    remove_column :shipment_stores, :shipment_refer, :string
    remove_index :users, :user_refer
    remove_index :shipment_stores, :shipment_refer
  end
end

