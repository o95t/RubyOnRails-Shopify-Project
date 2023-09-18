class AddPickupPostCodeRequired < ActiveRecord::Migration
  def up
		add_column :pickups, :pickup_post_code_required, :string
  end

  def down
		remove_column :pickups, :pickup_post_code_required, :string
  end
end
