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

class PickupStore < ActiveRecord::Base
  belongs_to :user
  attr_accessible :aramex_id, :guid, :product_group, :pickup_datetime, :reference1

  has_many :pickups
  has_many :pickup_stores

  validates_uniqueness_of :product_group, scope: [:user_id, :pickup_datetime]

  def form_label
  	"#{reference1} -- #{product_group} on #{pickup_datetime}"
  end
end
