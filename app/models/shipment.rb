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

class Shipment < ActiveRecord::Base

  belongs_to :user
  belongs_to :pickup_store

  # mount_uploader :attachment1, AttachmentUploader

  attr_accessible :actual_weight, :description_of_goods, :due_datetime, :goods_origin_country,
   :num_of_pieces, :payment_options, :payment_type, :product_group, :product_type, 
   :receiver_address_line1, :receiver_address_line2, :receiver_address_line3, :receiver_cellphone,
   :receiver_city, :receiver_company_name, :receiver_country_code, :receiver_email, :receiver_person_name,
   :receiver_post_code, :receiver_state_code, :shipper_address_line1, :shipper_address_line2,
   :shipper_address_line3, :shipper_cellphone, :shipper_city, :shipper_company_name, :shipper_country_code, 
   :shipper_email, :shipper_person_name, :shipper_post_code, :shipper_state_code, :shipping_datetime, 
   :order_id, :order_number, :third_party_address_line1, :third_party_address_line2, :third_party_address_line3, 
   :third_party_cellphone, :third_party_city, :third_party_company_name, :third_party_country_code, 
   :third_party_email, :third_party_person_name, :third_party_post_code, :third_party_state_code, 
   :shipper_account_number, :consignee_account_number, :third_party_account_number, :pickup_store_id, 
   :attachment1, :attachment2, :attachment3, :attachment4, :attachment5, :attachment6, :attachment7, 
   :attachment8, :attachment9, :attachment10, :services, :customs_value_amount, :cash_on_delivery, 
   :insurance_amount, :collect_amount, :update_shopify, :foreign_hawb, :shipment_refer, :receiver_refer, 
   :shipper_refer, :shipper_post_code_required, :receiver_post_code_required, :third_party_post_code_required, :customs_currency_code, :cod_currency_code, :number_pieces, :shipment_refer1, :location_id,
   :shipper_phone_number, :shipper_tax_id_vat, :shipper_state, :receiver_phone_number, :receiver_tax_id_vat, :receiver_state

  attr_accessor :shipper_account_number, :consignee_account_number, :third_party_account_number, :third_party_address_line1, :third_party_address_line2, :third_party_address_line3, :third_party_cellphone, :third_party_company_name, :third_party_country_code, :third_party_email, :third_party_person_name, :third_party_post_code, :third_party_city, :pickup_store_id, :attachment1, :attachment2, :attachment3, :attachment4, :attachment5, :attachment6, :attachment7, :attachment8, :attachment9, :attachment10, :services, :customs_value_amount, :cash_on_delivery, :insurance_amount, :collect_amount, :update_shopify, :foreign_hawb, :customs_currency_code,:cod_currency_code, :number_pieces, :cod, :shipment_refer1, :location_id

  validates_presence_of :payment_type, :shipper_person_name, :shipper_company_name, :shipper_cellphone, :shipper_email, :shipper_address_line1, :shipper_country_code, :receiver_person_name, :receiver_company_name, :receiver_cellphone,  :receiver_email, :receiver_address_line1, :receiver_country_code, :shipping_datetime, :due_datetime, :num_of_pieces, :actual_weight, :product_group, :product_type, :description_of_goods, :goods_origin_country, :order_id, :user_id, :order_number, :customs_value_amount, :cash_on_delivery, :insurance_amount, :collect_amount

  validates_presence_of :third_party_person_name, :third_party_company_name, :third_party_cellphone, :third_party_email, :third_party_address_line1, :third_party_city, :third_party_post_code, :third_party_country_code, :if => lambda {|shipment| shipment.payment_type == "3"}

  validate :pickup_validation

  validate :one_of_post_code_and_city_must_be_present

  validate :country_code_required_shipper
  validate :country_code_required_receiver
  validate :country_code_required_third_party

  # Either post code or city must be present
  def one_of_post_code_and_city_must_be_present
    if shipper_post_code.blank? && shipper_city.blank?
      errors.add :shipper_city, "Either city or post code must be filled."
    end

    if receiver_post_code.blank? && receiver_city.blank?
    	errors.add :receiver_city, "Either city or post code must be filled."
    end
  end

  #Post code required validation 

  def country_code_required_shipper
    if shipper_post_code_required == 'true' && shipper_post_code.blank?
      errors.add(:shipper_post_code, "Shipper post code must be filled.")
    end
  end

  def country_code_required_receiver
    if receiver_post_code_required == 'true' && receiver_post_code.blank?
      errors.add(:receiver_post_code, "Receiver post code must be filled.")
    end
  end

  def country_code_required_third_party
    if third_party_post_code_required == 'true' && third_party_post_code.blank?
      errors.add(:third_party_post_code, "Third party post code must be filled.")
    end
  end

  # End required validation 

# Check that the pickup group and product groups match
 def pickup_validation
 	unless pickup_store_id.blank?
 		unless product_group == PickupStore.find(pickup_store_id).product_group
 			errors.add(:pickup_store_id, " Product Groups for pickup do not match")
 		end
 	end
 end

 # Services is an array with first element "". We shift out the 1st element and then
 # convert the rest to comma seperated string
 def formatted_services
 	if services.first == ""
 		services.shift
 	end

 	services.join(',')
 end

  def self.product_groups_hash
  	{ "International Express" => "EXP",
  	  "Domestic" => "DOM"
  	}
  end

   # Hash of domestic product types
  def self.domestic_product_type_hash
  	{
  		"Special: Bulk Mail Delivery" => "BLK",
			"Domestic - Bullet Delivery" => "BLT",
			"Special Delivery" => "CDA",
			"Special: Credit Cards Delivery" => "CDS",
			"Air Cargo (India)" => "CGO",
			"Special: Cheque Collection" => "COM", 
			"Special: Invoice Delivery" => "DEC",
			"Early Morning delivery" => "EMD",
			"Special: Bank Branches Run" => "FIX",
			"Logistic Shipment" => "LGS",
			"Overnight (Document)" => "OND",
			"Overnight (Parcel)" => "ONP", 
			"Road Freight 24 hours service" => "P24",
			"Road Freight 48 hours service" => "P48", 
			"Economy Delivery" => "PEC",
			"Road Express" => "PEX",
			"Surface  Cargo (India)" => "SFC",
			"Same Day (Document)" => "SMD",
			"Same Day (Parcel)" => "SMP", 
			"Special: Legal Branches Mail Service" => "SPD",
			"Special : Legal Notifications Delivery" => "SPL",
			"Return" => "RTN"		
		}
  end

  # Hash of express(international) product types
  def self.express_product_type_hash
  	{
  	  "Value Express Parcels" => "DPX",
			"Economy Document Express" => "EDX",
			"Economy Parcel Express" => "EPX",
			"Ground Document Express" => "GDX",
			"Ground Parcel Express" => "GPX",
			"International defered" => "IBD",
			"Priority Document Express" => "PDX",
			"Priority Letter Express (<.5 kg Docs)" => "PLX",
			"Priority Parcel Express" => "PPX",
			"Return" => "RTN"
  	}
  end

  def self.domestic_services_hash
  	{
	  	"Morning delivery" => "AM10",
			"Chain Stores Delivery" => "CHST", 
			"Cash on Delivery Service" => "CODS",
			"Commercial" => "COMM",
			"Credit Card" => "CRDT",
			"Delivery Duty Paid – For European use" => "DDP",
			"Delivery duty unpaid – For the European freight" => "EXW",
			"Not an aramex customer – For European freight" => "INSR",
			"Insurance" => "INSR",
			"Return" => "RTRN",
			"Special Services" => "SPCL"
  	}
	end
	
	# Hash of express(international) product types
  def self.express_services_hash
  	{
"Morning delivery" => "AM10",
            "Cash on Delivery" => "CODS",
			"Shield" => "Shield",
			"FRDM" => "FRDM",
			"NULL" => "EUCO",			

            #{}"CSTM" => "CSTM",
            #{}"EUCO" => "EUCO",
            #{}"FDAC" => "FDAC",
            #{}"Free Domicile" => "FRD1",
            #{}"Free Domicile" => "FRDM",
            "Insurance" => "INSR",
            #{}"Noon Delivery" => "NOON",
            #{}"Over Size" => "ODDS",
            "Return" => "RTRN",
            #{}"Signature Required" => "SIGR",
            "Special Services" => "SPCL",
            "Chain Stores Delivery" => "CHST",
            "Commercial" => "COMM",
            "Credit Card" => "CRDT",
            "DDP - Delivery Duty Paid - For European Use" => "DDP",
            "DDU - Delivery Duty Unpaid - For the European Freight" => "DDU",
            "Not An Aramex Customer - For European Freight" => "EXW"
	  }
	end

  def self.shipping_information_hash
  	{ "Shipper" => "P",
  	  "Consignee" => "C",
  	  "Third Party" => "3"
  	}
  end

  def self.payment_types_hash
  	{ "Prepaid" => "P",
  	  "Collect" => "C",
  	  "Third Party" => "3"
  	}
  end

  def self.shipper_payment_options_hash
  	{
  		"Cash" => "CASH",
  		"Account" => "ACCT",
  		"Credit" => "CRDT"
  	}
  end

  def self.consignee_payment_options_hash
  	{
  		"ARCC" => "ARCC"
  	}
  end

  def self.services_hash
  	{
  		"Cash on Delivery"=> "CODS",
  		"First Delivery"=> "FIRST",
  		"Free Domicile"=> "FRDOM",
  		"Hold for pick up"=> "HFPU",
  		"Noon Delivery"=> "NOON",
  		"Signature Required"=> "SIG"
  	}
  end

  def self.update_shopify_hash
  	{
  		"Update Shopify and Notify Customer" => "1",
  		"Update Shopify Only" => "2",
  		"Not update Shopify" => "3"
  	}
  end

  # This generates a shipment hash
  def savon_hash(user)
	if customs_currency_code.blank?
		@customs_currency_code = user.currency_code
	else
		@customs_currency_code = customs_currency_code
	end
	if cod_currency_code.blank?
		@cod_currency_code = user.currency_code
	else
		@cod_currency_code = cod_currency_code
	end	
	
	
	#abort "#{shipment_refer1}".inspect
	
	
  	hash_before_filter =
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
		#reference1: "111111111111111113",
	  	#  reference2: "",
	  	#  reference3: "",
	  	  shipment:
	  		{ shipper:
	  			{ reference1: "#{shipper_refer}",
	  			  reference2: "",
	  			  account_number: "#{shipper_account_number}",
	  			  party_address:
	  				{
	  					line1: "#{shipper_address_line1}",
	  					line2: "#{shipper_address_line2}",
	  					line3: "#{shipper_address_line3}",
	  					city: "#{shipper_city}",
	  					state_or_province_code: "",
	  					post_code: "#{shipper_post_code}",
	  					country_code: "#{shipper_country_code}"
	  				},
	  			  contact:
	  			  	{
	  			  		department: "",
	  			  		person_name: "#{shipper_person_name}",
	  			  		title: "",
	  			  		company_name: "#{shipper_company_name}",
	  			  		phone_number1: "#{shipper_cellphone}",
	  			  		phone_number1_ext: "",
	  			  		phone_number2: "",
	  			  		phone_number2_ext: "",
	  			  		fax_number: "",
	  			  		cell_phone: "#{shipper_cellphone}",
	  			  		email_address: "#{shipper_email}",
	  			  		type: ""
	  			  	}
	  			}, # end of shipper
	  		  consignee:
	  		  	{  reference1: "#{receiver_refer}",
	  			   reference2: "",
	  			   account_number: "#{consignee_account_number}",
	  		  	   party_address:
	  				{
	  					line1: "#{receiver_address_line1}",
	  					line2: "#{receiver_address_line2}",
	  					line3: "#{receiver_address_line3}",
	  					city: "#{receiver_city}",
	  					state_or_province_code: "",
	  					post_code: "#{receiver_post_code}",
	  					country_code: "#{receiver_country_code}"
	  				},
	  			  contact:
	  			  	{
	  			  		department: "",
	  			  		person_name: "#{receiver_person_name}",
	  			  		title: "",
	  			  		company_name: "#{receiver_company_name}",
	  			  		phone_number1: "#{receiver_cellphone}",
	  			  		phone_number1_ext: "",
	  			  		phone_number2: "",
	  			  		phone_number2_ext: "",
	  			  		fax_number: "",
	  			  		cell_phone: "#{receiver_cellphone}",
	  			  		email_address: "#{receiver_email}",
	  			  		type: ""
	  			  	}
	  			}, # end of consignee
				#reference1: "#{receiver_refer}",
				#reference2: "#{receiver_refer}",
				reference1: "999999",
				reference2: "888888",
	  		  third_party:
	  		  	{  reference1: "",
	  			   reference2: "",
	  			   account_number: "#{third_party_account_number}",
	  		  	   party_address:
	  				{
	  					line1: "#{third_party_address_line1}",
	  					line2: "#{third_party_address_line2}",
	  					line3: "#{third_party_address_line3}",
	  					city: "#{third_party_city}",
	  					state_or_province_code: "",
	  					post_code: "#{third_party_post_code}",
	  					country_code: "#{third_party_country_code}"
	  				},
	  			  contact:
	  			  	{
	  			  		department: "",
	  			  		person_name: "#{third_party_person_name}",
	  			  		title: "",
	  			  		company_name: "#{third_party_company_name}",
	  			  		phone_number1: "#{third_party_cellphone}",
	  			  		phone_number1_ext: "",
	  			  		phone_number2: "",
	  			  		phone_number2_ext: "",
	  			  		fax_number: "",
	  			  		cell_phone: "#{third_party_cellphone}",
	  			  		email_address: "#{third_party_email}",
	  			  		type: ""
	  			  	}
	  			}, # end of consignee

	  		  shipping_date_time: "#{shipping_datetime}",
	  		  due_date: "#{due_datetime}",
	  		  comments: "",
	  		  pickup_location: "Shopify",
	  		  operations_instructions: "",
	  		  accounting_instrcutions: "",
	  		  details:
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
	  		  		number_of_pieces: "#{number_pieces}",
	  		  		product_group: "#{product_group}",
	  		  		product_type: "#{product_type}",
	  		  		payment_type: "#{payment_type}",
	  		  		payment_options: "#{payment_options}",
	  		  		customs_value_amount:
	  		  		{
	  		  			currency_code: "#{@customs_currency_code}",
	  		  			value: "#{customs_value_amount}"
	  		  		},
	  		  		cash_on_delivery_amount:
	  		  		{
	  		  			currency_code: "#{@cod_currency_code}",
	  		  			value: "#{cash_on_delivery}"
	  		  		},
	  		  		insurance_amount:
	  		  		{
	  		  			currency_code: "#{user.currency_code}",
	  		  			value: "#{insurance_amount}"
	  		  		},
	  		  		# cash_additional_amount:
	  		  		# {
	  		  		# 	currency_code: "#{user.currency_code}",
	  		  		# 	value: "0"
	  		  		# },
	  		  		# cash_additional_amount_description: "Default",
	  		  		collect_amount:
	  		  		{
	  		  			currency_code: "#{user.currency_code}",
	  		  			value: "#{collect_amount}"
	  		  		},
	  		  		services: "#{formatted_services}",
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
	  		  	}, # end of details
	  		   attachments: {
	  		   		attachment: attachments_arr # [attachment_hash(@attachment1), attachment_hash(@attachment1)]
	  		   	},
	  		   "ForeignHAWB" => "#{foreign_hawb}",
	  		   "TransportType_x0020_" => 0,
	  		   pickup_GUID: ""
	  		} # end of shipment
	  	},  #  end of shipments
  	  label_info:
  		{
  			reportID: "9729",
  			report_type: "URL"
  		}
  	}

  	# # Lets get those amounts which are zero
  	# zero_amounts = []

  	if cash_on_delivery == "0"
  		# zero_amounts.push :cash_on_delivery
  		hash_before_filter[:shipments][:shipment][:details].except!(:cash_on_delivery_amount)
  	end

  	if collect_amount == "0"
  		# zero_amounts.push :collect_amount
  		hash_before_filter[:shipments][:shipment][:details].except!(:collect_amount)
  	end

  	if insurance_amount == "0"
  		# zero_amounts.push :insurance_amount
  		hash_before_filter[:shipments][:shipment][:details].except!(:insurance_amount)
  	end

  	if customs_value_amount == "0"
  		# zero_amounts.push :customs_value_amount
  		hash_before_filter[:shipments][:shipment][:details].except!(:customs_value_amount)
  	end

  	hash_before_filter

  	# hash_before_filter[:shipments][:shipment][:details].except!(zero_amounts.join(','))
  end

  # Returns the full attachment hash (of arrays) for the shipment
  def attachments_arr
  	# Collect all the attachments in an array for easy iteration
  	attachments = [@attachment1, @attachment2, @attachment3, @attachment4, @attachment5, @attachment6, @attachment7, @attachment8, @attachment9, @attachment10]

  	result_arr = []
  	result_hash = {}

  	attachments.each do |attachment|
  		unless attachment.nil?
			result_arr.push attachment_hash(attachment)
  		end
  	end

  	# puts "============================="
  	# puts "result_arr = #{result_arr}"

  	result_arr
  end

  def attachment_hash(attachment)
  	# Get the filename and extension
	filename_array = attachment.original_filename.split('.')
	extension = filename_array.pop
	name = filename_array.join('.')
	# attachment.open.read

	{
		file_name: "#{name}",
		file_extension: "#{extension}",
		file_contents: "#{Base64.encode64(attachment.open.read)}"
	}

  end
end

