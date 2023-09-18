class AddShipperFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :shopify_email, :string
    add_column :users, :address_line1, :string
    add_column :users, :city, :string
    add_column :users, :post_code, :string
    add_column :users, :province, :string
    add_column :users, :country_code, :string
    add_column :users, :shopify_id, :string
    add_column :users, :currency_code, :string
    add_column :users, :time_zone, :string
  end
end
