class CreatePickups < ActiveRecord::Migration
  def change
    create_table :pickups do |t|
      t.string :pickup_address_line1
      t.string :pickup_address_line2
      t.string :pickup_address_line3
      t.string :pickup_cellphone
      t.string :pickup_company_name
      t.string :pickup_country_code
      t.string :pickup_email
      t.string :pickup_post_code
      t.string :pickup_person_name
      t.string :pickup_location
      t.datetime :pickup_datetime
      t.datetime :ready_time
      t.datetime :last_pickup_time
      t.datetime :closing_time
      t.string :reference1
      t.string :status
      t.string :product_group
      t.string :number_of_shipments
      t.string :number_of_pieces
      t.string :payment
      t.string :shipment_weight
      t.string :shipment_volume

      t.timestamps
    end
  end
end
