# == Schema Information
#
# Table name: shipments
#
#  id                     :integer          not null, primary key
#  payment_type           :string(255)
#  payment_options        :string(255)
#  shipper_person_name    :string(255)
#  shipper_company_name   :string(255)
#  shipper_cellphone      :string(255)
#  shipper_email          :string(255)
#  shipper_address_line1  :string(255)
#  shipper_address_line2  :string(255)
#  shipper_address_line3  :string(255)
#  shipper_city           :string(255)
#  shipper_state_code     :string(255)
#  shipper_post_code      :string(255)
#  shipper_country_code   :string(255)
#  receiver_person_name   :string(255)
#  receiver_company_name  :string(255)
#  receiver_cellphone     :string(255)
#  receiver_email         :string(255)
#  receiver_address_line1 :string(255)
#  receiver_address_line2 :string(255)
#  receiver_address_line3 :string(255)
#  receiver_city          :string(255)
#  receiver_state_code    :string(255)
#  receiver_post_code     :string(255)
#  receiver_country_code  :string(255)
#  shipping_datetime      :date
#  due_datetime           :date
#  num_of_pieces          :string(255)
#  actual_weight          :string(255)
#  product_group          :string(255)
#  product_type           :string(255)
#  description_of_goods   :string(255)
#  goods_origin_country   :string(255)
#  order_id               :string(255)
#  user_id                :integer
#  order_number           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Shipment do
  pending "add some examples to (or delete) #{__FILE__}"
end
