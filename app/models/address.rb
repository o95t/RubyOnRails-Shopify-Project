class Address
  # To make the model behave like an ActiveRecord model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  # Sets the accessor for the model
  attr_accessor :first_name, :last_name, :company, :phone, :email, :address1, :address2, :city, :zip, :country_code, :reference

  # Takes a shopify address and the corresponding email and returns an address object
  # @note Class method
  # @param shopify_address [Hash] The shopify address hash received from the order shopify API
  # @param email [String] The email of the user whose address we have received
  # @return address [Address] An address object
  
  def self.from_order(shopify_address, email)
  
   # address = Address.new
  #	address.first_name = shopify_address.first_name
  	#address.last_name = shopify_address.last_name
  	#address.company = shopify_address.company
  	#address.phone  = shopify_address.phone
  	#address.email = email
  	#address.address1 = shopify_address.address1
    #address.address2 = shopify_address.address2
  	#address.zip = shopify_address.zip
  	#address.country_code = shopify_address.country_code
    #address.city = shopify_address.city
    #address.reference = ""
  	#address
	 if shopify_address == false
address = Address.new
          address.first_name = ""
          address.last_name = ""
          address.company = ""
          address.phone  = ""
          address.email = ""
          address.address1 = ""
          address.address2 = ""
          address.zip = ""
          address.country_code = ""
          address.city = ""
address 
    else

    address = Address.new
    address.first_name = shopify_address.first_name
    address.last_name = shopify_address.last_name
    address.company = shopify_address.company
    address.phone  = shopify_address.phone
    address.email = email
    address.address1 = shopify_address.address1
    address.address2 = shopify_address.address2
    address.zip = shopify_address.zip
    address.country_code = shopify_address.country_code
    address.city = shopify_address.city
    address.reference = ""
    address 
     end
	
	
	
  end
  
  
  
  
  
  

 end
