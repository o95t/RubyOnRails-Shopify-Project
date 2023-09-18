class AddShipmentPostCodeRequired < ActiveRecord::Migration
  def up
  	add_column :shipments, :shipper_post_code_required, :string
  	add_column :shipments, :receiver_post_code_required, :string
  	add_column :shipments, :third_party_post_code_required, :string
	end

  def down
  	remove_column :shipments, :shipper_post_code_required, :string
  	remove_column :shipments, :receiver_post_code_required, :string
  	remove_column :shipments, :third_party_post_code_required , :string
  end
end
