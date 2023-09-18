class AddDefaultPaymentTypeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :default_payment_type, :string
  end
end
