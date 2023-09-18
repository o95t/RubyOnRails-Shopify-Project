class PickupsController < ApplicationController

	before_filter :valid_shopify_session, :logged_in_user
	around_filter :shopify_session, :except => 'welcome'

	def index
		@pickups = Pickup.paginate(page: params[:page], per_page: 5)
		@pickups = Pickup.where(status: params[:status]).paginate(page: params[:page], per_page: 5) if params[:status]
		@pickups = Pickup.where(reference1: params[:reference1]).paginate(page: params[:page], per_page: 5) if params[:reference1]
		@count_of_pages = @pickups.total_pages
	end	
	 
	def new
		@pickup = Pickup.new
		# Get the current shop data
		# @shop = ShopifyAPI::Shop.current

		@pickup.pickup_address_line1 = current_user.address.address1
		@pickup.pickup_cellphone = current_user.address.phone
		@pickup.pickup_company_name = current_user.address.company
		@pickup.pickup_country_code = current_user.address.country_code 
		@pickup.pickup_email = current_user.address.email 
		@pickup.pickup_person_name = "#{current_user.address.first_name} #{current_user.address.last_name}"
		@pickup.pickup_post_code = current_user.address.zip 
		@pickup.pickup_city = current_user.address.city
		@pickup.number_of_shipments = 0
		@countries = aramex_country_ar
		# debugger if Rails.env.development?
	
	end

	def aramex_country_code
		country_code_ar = Array.new
		countries = cached_countries || aramex_country_ar
		countries.map do |country|
			unless country[:code] != params[:country_code]
				country_code_ar << [country[:post_code_required]]
				break
  		end
  	end
    render :json => {:post_code_required => country_code_ar}.to_json
  end

  def aramex_address_validate
  	@user_hash = {
      client_info: 
      { 
        user_name: current_user.email,
		  	password: current_user.password,
		  	version: "v1.0",
		  	account_number: current_user.account_number,
		  	account_pin: current_user.account_pin,
		  	account_entity: current_user.account_entity,
		  	account_country_code: current_user.country_code
      },
			address: {
				line1: '001',
				line2: '',
				line3: '',
				city: 'Test',
				state_or_province_code: '',
				post_code: params[:post_code],
				country_code: params[:country_code]	
				# post_code: '2198',
				# country_code: 'ZA'	
			}
    }
    
    location_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
      wsdl "#{ShopifyAramex::Application.config.location_wsdl}"
      convert_request_keys_to :camelcase
    end
    
    address_response = location_client.call(:validate_address, message: @user_hash)
	  render json: address_response.body[:address_validation_response][:suggested_addresses].to_json
    # return @address_response.body[:address_validation_response][:suggested_addresses]
    # render text: service_ar.to_json
  end

  def aramex_country_city

  	@user_hash = {
      client_info: 
      { 
        user_name: current_user.email,
		  	password: current_user.password,
		  	version: "v1.0",
		  	account_number: current_user.account_number,
		  	account_pin: current_user.account_pin,
		  	account_entity: current_user.account_entity,
		  	account_country_code: current_user.country_code
      },
			country_code: params[:country_code],	
			name_starts_with: params[:country_city]	
		}
    
    location_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
      wsdl "#{ShopifyAramex::Application.config.location_wsdl}"
      convert_request_keys_to :camelcase
    end
    cities_response = location_client.call(:fetch_cities, message: @user_hash)
	  render json: cities_response.body[:cities_fetching_response][:cities][:string].to_json

  end

  def create
		@has_error = false 
		@aramex_error_msg = ""

		@params = Pickup.format_params(params)

		@pickup = Pickup.new(params[:pickup])
		@pickup.last_pickup_time = @pickup.closing_time

		# Proceed if the pickup object we recived is valid
		if @pickup.valid?

			@message_hash = { client_info: current_user.shipping_savon_hash  }
			@message_hash.merge!  @pickup.savon_hash

			shipping_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
 				wsdl "#{ShopifyAramex::Application.config.shipping_wsdl.to_s}"
 				convert_request_keys_to :camelcase
 			end
 			
logger.info "#{Time.now}  #{shop_session.url}  Pickup request  #{@message_hash.inspect}"		   
 			@response = shipping_client.call(:create_pickup, message: @message_hash)
logger.info "#{Time.now}  #{shop_session.url}  Pickup response  #{@response.body.inspect}"
 			# Check if the reponse has errors
 			if @response.body[:pickup_creation_response][:has_errors]
 				@has_error = true
 				@notifications = @response.body[:pickup_creation_response][:notifications][:notification]

 				# When there is only one error, response gives us a hash but for multiple errors, we 
 				# get an array of hashes. So, we convert hash in to array of hashes 
 				if @notifications.class == {}.class
 					@notifications = [] << @notifications
 				end
 				@notifications.each do |notification|
 					@aramex_error_msg += "#{notification[:message]} <br />"
 				end	
 			else
 				@aramex_id = @response.body[:pickup_creation_response][:processed_pickup][:id]
 				@guid = @response.body[:pickup_creation_response][:processed_pickup][:guid]

 				# The pickup model is only to properly place all the values. 
 				# We are only saving essential data in PickupStore

 				@pickup_store = current_user.pickup_stores.create(aramex_id: @aramex_id, guid: @guid, product_group: @pickup.product_group, pickup_datetime: @pickup.pickup_datetime, reference1: @pickup.reference1)

 				# debugger if Rails.env.development?

 				# Check whether pickup_store worked 

 				if @pickup_store.id.nil?
 					# Wasn't saved in the Rails app 
 					@has_error = true
 					@aramex_error_msg += "Pickup was created on Aramax but we faced an error and couldn't save it <br /> #{@pickup_store.errors.full_messages}"
 				end
 				# The else is missing which will be called if @has_error is false and render the @pickup_store
  			end
		else
			@has_error = true
		end

		if @has_error
			flash.now[:error] = "Error in creating your pickup. Please fix it and try again. 
							<p><strong>#{@aramex_error_msg}</strong></p>"
		
			render 'new'
		end
	end
end
