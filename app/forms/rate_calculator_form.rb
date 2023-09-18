class RateCalculatorForm
	#   Rails 4: include ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  attr_accessor :origin_address_line1, :origin_address_line2, :origin_address_line3, :origin_post_code, :origin_city, :origin_country_code, :origin_post_code_required, :destination_address_line1, :destination_address_line2, :destination_address_line3, :destination_post_code, :destination_city, :destination_post_code_required,  :destination_country_code, :actual_weight, :num_of_pieces, :payment_type, :product_group, :product_type, :description_of_goods, :goods_origin_country

  validates_presence_of :origin_address_line1, :origin_country_code, :destination_address_line1, :destination_country_code, :actual_weight, :num_of_pieces, :payment_type, :product_group, :product_type, :description_of_goods, :goods_origin_country

  validate :one_of_post_code_and_city_must_be_present
  validate :country_code_required_origin
  validate :country_code_required_destination

  # Either post code or city must be present
  def one_of_post_code_and_city_must_be_present
    if origin_post_code.blank? && origin_city.blank?
      errors.add :origin_city, "Either city or post code must be filled."
    end

    if destination_post_code.blank? && destination_city.blank?
    	errors.add :destination_city, "Either city or post code must be filled."
    end
  end

  #Post code required validation 

  def country_code_required_origin
    if origin_post_code_required == 'true' && origin_post_code.blank?
      errors.add(:origin_post_code, "Origin post code must be filled.")
    end
  end

  def country_code_required_destination
    if destination_post_code_required == 'true' && destination_post_code.blank?
      errors.add(:destination_post_code, "Destination post code must be filled.")
    end
  end


  def initialize(params)
  	unless params.nil?
	  	@origin_address_line1 = params[:origin_address_line1]
	  	@origin_address_line2 = params[:origin_address_line2]
	  	@origin_address_line3 = params[:origin_address_line3]
	  	@origin_post_code = params[:origin_post_code]
	  	@origin_city = params[:origin_city]
	  	@origin_country_code = params[:origin_country_code]
	  	@destination_address_line1 = params[:destination_address_line1]
	  	@destination_address_line2 = params[:destination_address_line2]
	  	@destination_address_line3 = params[:destination_address_line3]
	  	@destination_post_code = params[:destination_post_code]
	  	@destination_city = params[:destination_city]
	  	@destination_country_code = params[:destination_country_code]
	  	@actual_weight = params[:actual_weight]
	  	@num_of_pieces = params[:num_of_pieces]
	  	@payment_type = params[:payment_type]
	  	@product_group = params[:product_group]
	  	@product_type = params[:product_type]
	  	@description_of_goods = params[:description_of_goods]
	  	@goods_origin_country = params[:goods_origin_country]
	end
  end

  # This generates a hash for rate calculation API 
  def savon_hash
  	{ 	transaction: 
  		{
  			reference1: "",
  			reference2: "",
  			reference3: "",
  			reference4: "",
  			reference5: ""
  		},
  		origin_address:
  		{
  			line1: "#{origin_address_line1}",
			line2: "#{origin_address_line2}",
			line3: "#{origin_address_line3}",
			city: "#{origin_city}",
			state_or_province_code: "",
			post_code: "#{origin_post_code}",
			country_code: "#{origin_country_code}"
  		},
  		destination_address:
  		{
  			line1: "#{destination_address_line1}",
			line2: "#{destination_address_line2}", 
			line3: "#{destination_address_line3}",
			city: "#{destination_city}",
			state_or_province_code: "",
			post_code: "#{destination_post_code}",
			country_code: "#{destination_country_code}"
		},
		shipment_details:
	  	{
	  		dimensions: 
	  		{
  				length: "0",
  				width: "0",
  				height: "0",
  				unit: "cm"
	  		},
	  		actual_weight: 
	  		{
				unit: "KG",
	  			value: "#{actual_weight}"
	  		},
	  		chargeable_weight: 
	  		{
  				unit: "KG",
  				value: "#{actual_weight}"
	  		},
	  		description_of_goods: "#{description_of_goods}",
	  		goods_origin_country: "#{goods_origin_country}",
	  		number_of_pieces: "#{num_of_pieces}",
	  		product_group: "#{product_group}",
	  		product_type: "#{product_type}",
	  		payment_type: "#{payment_type}",
	  		payment_options: "",
	  		services: "",
	  		items: 
	  		{
	  		 	shipment_item:
	  		 	{
	  		 		package_type: "Default",
	  		 		quantity: "#{num_of_pieces}",
	  		 		weight: 
	  		 		 {
	  					unit: "KG",
	  					value: "#{actual_weight}"
	  		 		 },
	  		 		comments: "Default",
	  		 		reference: ""
	  		 	}
	  		} # end of items
	  	} # end of shipment details 
	}

  end
end
