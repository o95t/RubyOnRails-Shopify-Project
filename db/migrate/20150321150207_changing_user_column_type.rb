class ChangingUserColumnType < ActiveRecord::Migration
  def up
  	change_column :users, :default_domestic_product_type, :string, :default => nil
    change_column :users, :default_international_product_type, :string, :default => nil
  	
  	change_column :users, :default_domestic_services, :string, :default => nil
	change_column :users, :default_international_services, :string, :default => nil
  end

  def down
  	change_column :users, :default_domestic_product_type, :string
    change_column :users, :default_international_product_type, :string
  	
  	change_column :users, :default_domestic_services, :string
	change_column :users, :default_international_services, :string
  end
end
