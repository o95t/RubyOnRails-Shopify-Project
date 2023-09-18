# == Schema Information
#
# Table name: shipment_stores
#
#  id           :integer          not null, primary key
#  order_id     :string(255)
#  user_id      :integer
#  awb          :string(255)
#  label_url    :string(255)
#  order_number :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  payment_type :string(255)
#

class ShipmentStore < ActiveRecord::Base
  belongs_to :user
  attr_accessible :awb, :label_url, :order_id, :order_number, :payment_type, :receiver_refer, :shipper_refer, :shipment_refer

  validates_presence_of :awb, :label_url, :order_id, :order_number, :payment_type
  validates_uniqueness_of :awb
  # validates_uniqueness_of :order_id, scope: :payment_type

  def print_label_hash
  	{ 	transaction:
  		{
  			reference1: "",
  			reference2: "",
  			reference3: "",
  			reference4: "",
  			reference5: ""
  		},
  		shipment_number: "#{awb}",
  		product_group: "",
  		origin_entity: "",
  	  	label_info:
  		{
  			reportID: "9729",
  			report_type: "URL"
  		}
  	}
  end

  def tracking_hash
  	{ 	transaction:
  		{
  			reference1: "",
  			reference2: "",
  			reference3: "",
  			reference4: "",
  			reference5: ""
  		},
  		shipments:
  		{
  			'ins0:string' => ["#{awb}"]
  		},
  		get_last_tracking_update_only: 0
  	}
  end


end
