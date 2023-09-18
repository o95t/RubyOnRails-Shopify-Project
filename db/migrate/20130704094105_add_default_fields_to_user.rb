class AddDefaultFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_domestic_product_type, :string
    add_column :users, :default_international_product_type, :string
    add_column :users, :default_prepaid_payment_option, :string
  end
end
