# == Schema Information
#
# Table name: users
#
#  id                                 :integer          not null, primary key
#  shop_name                          :string(255)
#  shop_url                           :string(255)
#  account_country_code               :string(255)
#  account_entity                     :string(255)
#  account_number                     :string(255)
#  account_pin                        :string(255)
#  email                              :string(255)
#  password                           :string(255)
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  remember_token                     :string(255)
#  shipper_name                       :string(255)
#  company_name                       :string(255)
#  cellphone                          :string(255)
#  shopify_email                      :string(255)
#  address_line1                      :string(255)
#  city                               :string(255)
#  post_code                          :string(255)
#  province                           :string(255)
#  country_code                       :string(255)
#  shopify_id                         :string(255)
#  currency_code                      :string(255)
#  default_domestic_product_type      :string(255)
#  default_international_product_type :string(255)
#  default_prepaid_payment_option     :string(255)
#  default_product_group              :string(255)
#  default_payment_type               :string(255)
#

require 'spec_helper'

describe User do
  before do 
  	@user = User.new(shop_url: "example-app.myshopify.com", account_country_code: "IN", account_entity: "BOM", 
  		account_number: "123456789", account_pin: "123456", 
  		email: "test@example.com", password: "password")
  end

  subject { @user }

  it { should respond_to(:shop_url)}
  it { should respond_to(:account_country_code)}
  it { should respond_to(:account_entity)}
  it { should respond_to(:account_number)}
  it { should respond_to(:account_pin)}
  it { should respond_to(:email)}
  it { should respond_to(:password)}
  it { should respond_to(:remember_token) }

  it {  should be_valid }
end
