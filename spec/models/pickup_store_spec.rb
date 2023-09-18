# == Schema Information
#
# Table name: pickup_stores
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  aramex_id       :string(255)
#  guid            :string(255)
#  product_group   :string(255)
#  pickup_datetime :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reference1      :string(255)
#

require 'spec_helper'

describe PickupStore do
  pending "add some examples to (or delete) #{__FILE__}"
end
