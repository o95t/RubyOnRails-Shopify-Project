class AddDefaultServicesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :default_domestic_services, :string
  	add_column :users, :default_international_services, :string
  end
end
