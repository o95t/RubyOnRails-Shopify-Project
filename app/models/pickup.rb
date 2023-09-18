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

class Pickup < ActiveRecord::Base
  attr_accessible :closing_time, :last_pickup_time, :number_of_pieces, :number_of_shipments, :payment, :pickup_address_line1, :pickup_address_line2, :pickup_address_line3, :pickup_cellphone, :pickup_city, :pickup_company_name, :pickup_country_code, :pickup_email, :pickup_location, :pickup_person_name, :pickup_post_code, :product_group, :product_type, :pickup_datetime, :ready_time, :reference1, :status, :shipment_weight, :shipment_volume, :pickup_post_code_required

  validates_presence_of :pickup_person_name, :pickup_company_name, :pickup_cellphone, :pickup_email, :pickup_address_line1, :pickup_country_code, :pickup_location, :ready_time, :last_pickup_time, :closing_time, :reference1, :status, :product_group, :product_type, :number_of_shipments, :number_of_pieces, :payment

  validate :closing_time_greater_than_ready_time
  validate :one_of_post_code_and_city_must_be_present
  validate :country_code_required

  def closing_time_greater_than_ready_time
    unless closing_time > ready_time
      errors.add(:closing_time, "Closing Time should be after Ready Time.")
    end
  end

  # Either post code or city must be present
  def one_of_post_code_and_city_must_be_present
    if pickup_post_code.blank? && pickup_city.blank?
      errors.add(:pickup_city, "Either city or post code must be filled.")
    end
  end

  def country_code_required
    if pickup_post_code_required == 'true' && pickup_post_code.blank?
      errors.add(:pickup_post_code, "")
    end
  end

  def format_datetimes
    pickup_date = @pickup_datetime.to_date.to_s

    ready_time_only = @ready_time.to_time.to_formatted_s(:time) # Returns Time only in UTC

    # This takes pickup's date and then combines it with ready time
    correct_ready_datetime = Time.zone.parse("#{pickup_date} #{ready_time_only} UTC")
    @ready_time = correct_ready_datetime 

    closing_time_only = @closing_time.to_time.to_formatted_s(:time) # Returns Time only in UTC

    # This takes pickup's date and then combines it with closing time
    correct_closing_datetime = Time.zone.parse("#{pickup_date} #{closing_time_only} UTC")
    @closing_time = correct_closing_datetime 

    @last_pickup_time = @closing_time
  end

  # Will take the form params, fix them -- this will make the ready time and closing time dates to be the same as that of the pickup date. By default, they will be current date and return.
  # These times are converted to UTC before being sent to Aramex API 
  def self.format_params(params)
    # Set the date for ready_time and closing_time same as pickup_date

    params[:pickup]["ready_time(1i)"] = params[:pickup]["closing_time(1i)"] = params[:pickup]["pickup_datetime(1i)"]
    params[:pickup]["ready_time(2i)"] = params[:pickup]["closing_time(2i)"] = params[:pickup]["pickup_datetime(2i)"]
    params[:pickup]["ready_time(3i)"] = params[:pickup]["closing_time(3i)"] = params[:pickup]["pickup_datetime(3i)"] 

    # Sets the default pickup_datetime's time to 00:01
    # Without this, pickup_date moves to the next day
    params[:pickup]["pickup_datetime(4i)"] = "00"
    params[:pickup]["pickup_datetime(5i)"] = "01"

    params

  end

  def savon_hash
		{ 	transaction: 
	  		{
	  			reference1: "",
	  			reference2: "",
	  			reference3: "",
	  			reference4: "",
	  			reference5: ""
	  		},
	  		pickup:
	  		{
	  			pickup_address: 
	  			{
	  				line1: "#{pickup_address_line1}",
	  				line2: "#{pickup_address_line2}",
	  				line3:"#{pickup_address_line3}",
	  				city: "#{pickup_city}",
	  				state_or_province_code: "",
	  				post_code: "#{pickup_post_code}",
	  				country_code: "#{pickup_country_code}"
	  			},
	  			pickup_contact:
  			  	{
  			  		department: "",
  			  		person_name: "#{pickup_person_name}",
  			  		title: "",
  			  		company_name: "#{pickup_company_name}",
  			  		phone_number1: "#{pickup_cellphone}",
  			  		phone_number1_ext: "",
  			  		phone_number2: "",
  			  		phone_number2_ext: "",
  			  		fax_number: "",
  			  		cell_phone: "#{pickup_cellphone}",
  			  		email_address: "#{pickup_email}",
  			  		type: ""
  			  	},
  			  	pickup_location: "#{pickup_location}",
  			  	pickup_date: "#{pickup_datetime.utc.xmlschema}",
  			  	ready_time: "#{ready_time.utc.xmlschema}",
  			  	last_pickup_time: "#{last_pickup_time.utc.xmlschema}",
  			  	closing_time: "#{closing_time.utc.xmlschema}",
  			  	comments: "",
  			  	reference1: "#{reference1}",
  			  	reference2: "",
  			  	vehicle: "", # Ignoring shipments after this
  			  	pickup_items: 
  			  	{
  			  		pickup_item_detail:
  			  		{
  			  			product_group: "#{product_group}",
  			  			product_type: "#{product_type}",
  			  			number_of_shipments: "#{number_of_shipments}",
  			  			package_type: "",
  			  			payment: "#{payment}",   			  			
  			  			shipment_weight:
  			  			{
  			  				unit: "KG",
  			  				value: "1"
  			  			},
  			  			shipment_volume:
  			  			{
  			  				unit: "Cm3",
  			  				value: "1"
  			  			},
  			  			number_of_pieces: "#{number_of_pieces}",
  			  			cash_amount: 
  			  			{
  			  				currency_code: "INR",
  			  				value: "0.00"
  			  			}, 
  			  			extra_charges: 
  			  			{
  			  				currency_code: "INR",
  			  				value: "0.00"
  			  			},
  			  			shipment_dimensions: 
	  		  			{
	  		  				length: "0",
	  		  				width: "0",
	  		  				height: "0",
	  		  				unit: "cm"
	  		  			},
  			  			comments: ""
  			  		}
  			  	},
  			  	status: "#{status}"
	  		} # Ignoring label_info
	  	}
	end
end
