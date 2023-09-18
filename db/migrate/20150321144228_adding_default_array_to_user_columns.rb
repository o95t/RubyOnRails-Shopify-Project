class AddingDefaultArrayToUserColumns < ActiveRecord::Migration
  def change
  	change_column :users, :default_domestic_product_type, :string, array:true, default:[]
    change_column :users, :default_international_product_type, :string, array:true, default:[]
  	
  	change_column :users, :default_domestic_services, :string, array:true, default: []
	change_column :users, :default_international_services, :string, array:true, default: []
  end

end
