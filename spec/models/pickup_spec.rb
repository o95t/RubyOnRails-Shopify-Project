# == Schema Information
#
# Table name: pickups
#
#  id                   :integer          not null, primary key
#  pickup_address_line1 :string(255)
#  pickup_address_line2 :string(255)
#  pickup_address_line3 :string(255)
#  pickup_cellphone     :string(255)
#  pickup_company_name  :string(255)
#  pickup_country_code  :string(255)
#  pickup_email         :string(255)
#  pickup_post_code     :string(255)
#  pickup_person_name   :string(255)
#  pickup_location      :string(255)
#  pickup_datetime      :datetime
#  ready_time           :datetime
#  last_pickup_time     :datetime
#  closing_time         :datetime
#  reference1           :string(255)
#  status               :string(255)
#  product_group        :string(255)
#  number_of_shipments  :string(255)
#  number_of_pieces     :string(255)
#  payment              :string(255)
#  shipment_weight      :string(255)
#  shipment_volume      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  pickup_city          :string(255)
#  product_type         :string(255)
#

require 'spec_helper'

describe Pickup do
  pending "add some examples to (or delete) #{__FILE__}"
end
