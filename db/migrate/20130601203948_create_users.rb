class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :shop_name
      t.string :shop_url
      t.string :account_country_code
      t.string :account_entity
      t.string :account_number
      t.string :account_pin
      t.string :email
      t.string :password
      t.string :shipper_name
      t.string :company_name
      t.string :cellphone


      t.timestamps
    end

    add_index :users, :account_number, unique: true
    add_index :users, :email, unique: true
    add_index :users, :shop_url, unique: true
  end
end
