class AddCodAccountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :allowed_cod, :string,  default: 'no'
    add_column :users, :cod_account_number, :string
    add_column :users, :cod_account_pin, :string
    add_column :users, :cod_account_entity, :string
    add_column :users, :cod_account_country_cod, :string
  end
end
