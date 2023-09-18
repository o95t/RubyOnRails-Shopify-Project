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

class User < ActiveRecord::Base
  # Specify which attributes are accessible by mass-assignment
  
  attr_accessible :shop_name, :shop_url, :account_country_code, :account_entity, :account_number,
  	:account_pin, :email, :password, :shipper_name, :company_name, :cellphone, :address_line1, :city, 
     :province, :post_code, :country_code, :shopify_email, :shopify_id, :currency_code, 
    :default_domestic_product_type, :default_international_product_type, :default_prepaid_payment_option, 
    :default_product_group, :default_payment_type, :user_refer, :default_domestic_services, :default_international_services, :mode, :auto

  attr_accessor :update_shopify_information
  
  serialize :default_domestic_product_type
  serialize :default_international_product_type
  serialize :default_domestic_services
  serialize :default_international_services

  
  before_validation do |model|
    model.default_domestic_product_type.reject!(&:blank?) if model.default_domestic_product_type
    model.default_international_product_type.reject!(&:blank?) if model.default_international_product_type
    model.default_domestic_services.reject!(&:blank?) if model.default_domestic_services
    model.default_international_services.reject!(&:blank?) if model.default_international_services
  end
  # Adds validations for the model

  validates_presence_of :shop_url, :account_country_code, :account_entity, :account_number, 
  :account_pin, :email, :password, :shipper_name, :company_name, :cellphone, :address_line1, 
  :city, :country_code, :shopify_email, :shopify_id, :currency_code, :default_domestic_product_type,
  :default_international_product_type

  # validates :account_number, uniqueness: true
  validates :shop_url, uniqueness: { case_sensitive: false}
  # validates :email, uniqueness: { case_sensitive: false }

  #### New changes #####

  validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,14}\z/

  validates_length_of :account_entity, :maximum => 3, :minimum => 3, :message => "Need to be 3 character"

  validates_format_of :account_entity, :with => /\A[a-zA-Z]+\z/, :message => "Can only contain characters"

  ###################
  before_create :create_remember_token

  has_many :shipments
  has_many :shipment_stores, dependent: :destroy

  has_many :pickup_stores, dependent: :destroy

  # Savon_hash will be included in all requests as client_info
  def savon_hash
    {
      user_name: "#{email}",
      password: "#{password}",
      version: "1.0",
      account_number: "#{account_number}",
      account_pin: "#{account_pin}",
      account_entity: "#{account_entity}",
      account_country_code: "#{account_country_code}"
    }
  end

  def shipping_savon_hash
    {
      user_name: "#{email}",
      password: "#{password}",
      version: "1.0",
      account_number: "#{account_number}",
      account_pin: "#{account_pin}",
      account_entity: "#{account_entity}",
      account_country_code: "#{account_country_code}",
      source: 32
    }
  end

  # This method will return an address object similar to the address objects
  # returned by the Shopify API
  def address
    addr = Address.new

    name_array = self.shipper_name.split(' ')
    addr.first_name = name_array.shift # Returns the first name
    addr.last_name = name_array.join(' ')

    addr.company = self.company_name
    addr.phone = self.cellphone
    addr.email = self.shopify_email
    addr.address1 = self.address_line1
    addr.address2 = ""
    addr.zip = self.post_code
    addr.country_code = self.country_code
    addr.city = self.city
    addr.reference = self.user_refer
    addr
  end

  # @return The default product type hash for this user
  # @note This depends on the default product group. If that is not set,
  #   assumes it to be DOM
  def default_product_type_hash
    product_ar = []
    if self.default_product_group ==  "EXP"
      @express_product = self.default_international_product_type
      @express_product.sort.each do |hash|
        Shipment.express_product_type_hash.sort.each do |k, v|  
          product_ar << [k, v] if hash == v    
        end
      end
    else
      @domestic_product = self.default_domestic_product_type
      @domestic_product.sort.each do |hash|
        Shipment.domestic_product_type_hash.sort.each do |k, v|  
          product_ar << [k, v] if hash == v    
        end
      end
    end
    product_ar    
  end

  # @return The default product type for this user
  # @note This depends on the default product group again, If that is not set,
  #   assumes it to be DOM
  def default_product_type
    product_ar = []
    if self.default_product_group ==  "EXP"
      @express_product = self.default_international_product_type
      @express_product.sort.each do |hash|
        Shipment.express_product_type_hash.sort.each do |k, v|  
          product_ar << [k, v] if hash == v    
        end
      end
    else
      @domestic_product = self.default_domestic_product_type
      @domestic_product.sort.each do |hash|
        Shipment.domestic_product_type_hash.sort.each do |k, v|  
          product_ar << [k, v] if hash == v    
        end
      end
    end
    product_ar    
  end

  def default_services_hash
    service_ar = []
    if self.default_product_group ==  "EXP"
      @express_services = self.default_international_services
      @express_services.sort.each do |hash|
        Shipment.express_services_hash.sort.each do |k, v|  
          service_ar << [k, v] if hash == v    
        end
      end
    else
      @domestic_services = self.default_domestic_services
      @domestic_services.sort.each do |hash|
        Shipment.domestic_services_hash.sort.each do |k, v|  
          service_ar << [k, v] if hash == v    
        end
      end
    end
    service_ar    
  end


  # def self.all_country_hash
  #   { "Priority Document Express" => "PDX",
  #     "Priority Parcel Express" => "PPX",
  #     "Priority Letter Express" => "PLX",
  #     "Deferred Document Express" => "DDX",
  #     "Deferred Parcel Express" => "DPX",
  #     "Ground Document Express" => "GDX",
  #     "Ground Parcel Express" => "GPX",
  #     "Economy Parcel Express" => "EPX",
  #     "Economy Document Express" => "EDE",
  #     "Value Express Parcels" => "VEP",

  #   }

  # end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
