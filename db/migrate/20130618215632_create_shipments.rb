class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :payment_type
      t.string :payment_options
      t.string :shipper_person_name
      t.string :shipper_company_name
      t.string :shipper_cellphone
      t.string :shipper_email
      t.string :shipper_address_line1
      t.string :shipper_address_line2
      t.string :shipper_address_line3
      t.string :shipper_city
      t.string :shipper_state_code
      t.string :shipper_post_code
      t.string :shipper_country_code
      t.string :receiver_person_name
      t.string :receiver_company_name
      t.string :receiver_cellphone
      t.string :receiver_email
      t.string :receiver_address_line1
      t.string :receiver_address_line2
      t.string :receiver_address_line3
      t.string :receiver_city
      t.string :receiver_state_code
      t.string :receiver_post_code
      t.string :receiver_country_code
      t.date :shipping_datetime
      t.date :due_datetime
      t.string :num_of_pieces
      t.string :actual_weight
      t.string :product_group
      t.string :product_type
      t.string :description_of_goods
      t.string :goods_origin_country
      t.string :order_id
      t.integer :user_id
      t.string :order_number

      t.timestamps
    end

    add_index :shipments, :order_id
    add_index :shipments, :user_id
  end
end
