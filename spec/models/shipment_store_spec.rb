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

require 'spec_helper'

describe ShipmentStore do
  pending "add some examples to (or delete) #{__FILE__}"
end
