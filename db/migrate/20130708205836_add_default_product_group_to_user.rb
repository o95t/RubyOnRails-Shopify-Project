class AddDefaultProductGroupToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_product_group, :string
  end
end
