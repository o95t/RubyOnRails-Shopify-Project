class UsersController < ApplicationController

	before_filter :valid_shopify_session
	before_filter :logged_in_user, only: [:edit, :update, :update_shopify_info]

	around_filter :shopify_session, only: [:create, :update_shopify_info, :update]
	
	#before_filter :update_shopify_info, only: [:update]

	layout 'unauthorized', only: [:new]
	
	def create
				
		# Check if shop_url has not been tampered in form by matching it with the value in session
		@user = User.new(params[:user])

		@user.shop_url = session[:shopify].url

		# Set other data from Shopify

		@shop = ShopifyAPI::Shop.current

		@user.assign_attributes(
			address_line1: @shop.address1,
			city: @shop.city,
			country_code: @shop.country,
			shopify_id: @shop.id,
			company_name: @shop.name,
			cellphone: @shop.phone,
			post_code: @shop.zip,
			currency_code: @shop.currency,
			shipper_name: @shop.shop_owner,
			shopify_email: @shop.email
		)

		@user.assign_attributes(province: @shop.province) unless @shop.province.nil?
		if @user.save
			flash[:success] = "Successfully added Aramex account information"
			login(@user)
			redirect_to root_url
		else
		flash.now[:error] = @user.errors.messages.inspect
			#flash.now[:error] = "Oops! There was some error. Please try again."
			render "new"
		end
	end

	def new

		@box = 1
		@user = User.new

		if @user.email.nil?
			#@user.email = 'testingapi@aramex.com'
		end
		if @user.password.nil?
			#@user.password = 'R123456789$r'	
		end
		if @user.account_number.nil?
			#@user.account_number = '20016'	
		end
		if @user.account_pin.nil?
			#@user.account_pin = '543543'	
		end
		if @user.account_entity.nil?
			#@user.account_entity = 'AMM'	
		end
		if @user.account_country_code.nil?
			#@user.account_country_code = 'JO'	
		end
		
		@user.shop_url = session[:shopify].url
	end

	# If the user changes some info on Shopify, and wants to update the app with the same
	def update_shopify_info

		unless current_user.nil?

			@shop = ShopifyAPI::Shop.current

			if current_user.update_attributes(
					address_line1: @shop.address1,
					city: @shop.city,
					country_code: @shop.country,
					shopify_id: @shop.id,
					company_name: @shop.name,
					cellphone: @shop.phone,
					post_code: @shop.zip,
					currency_code: @shop.currency,
					shipper_name: @shop.shop_owner,
					province: @shop.province,
					shopify_email: @shop.email
				 )
				#flash[:notice] = "Shopify information updated successfully"
				#redirect_to :back
			else
				flash[:error] = "Shopify information could not be updated. <br /> #{current_user.errors.full_messages}"
				redirect_to '/edit'
			end
		else
			flash[:error] = "Please login first"
			redirect_to '/login'
		end
	end

	def edit
		@user = current_user
	end

	def update

		unless current_user.nil?

			@shop = ShopifyAPI::Shop.current

			if current_user.update_attributes(
					address_line1: @shop.address1,
					city: @shop.city,
					country_code: @shop.country,
					shopify_id: @shop.id,
					company_name: @shop.name,
					cellphone: @shop.phone,
					post_code: @shop.zip,
					currency_code: @shop.currency,
					shipper_name: @shop.shop_owner,
					province: @shop.province,
					shopify_email: @shop.email
				 )
				#flash[:notice] = "Shopify information updated successfully"
				#redirect_to :back
			else
				flash[:error] = "Shopify information could not be updated. <br /> #{current_user.errors.full_messages}"
				redirect_to '/edit'
			end
		else
			flash[:error] = "Please login first"
			redirect_to '/login'
		end	

#logger.info  current_user.inspect




if params[:user][:mode] == '' || params[:user][:mode] == 'true' || params[:user][:mode] == 'yes'

	require 'uri'
	require 'net/http'
	require "json"


	# GET carrier_services
	uri = URI.parse("https://" + shop_session.url + "/admin/carrier_services.json")
	response = Net::HTTP.new(uri.host, uri.port)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.path, initheader = {'Content-Type' =>'application/json', 'X-Shopify-Access-Token' => shop_session.token})
	http.request(request)
	response = http.request(request)
	@parsed_json = JSON.parse(response.body)

	if @parsed_json['carrier_services'].present?
	 @parsed_json['carrier_services'].each do |doc|
	 if doc["name"] == "Aramex" 
		@carrier_services = doc["id"]
		end
	 end
	end
logger.info "#{Time.now}  #{shop_session.url} Old carrier_services #{JSON.parse(response.body).inspect}"
#abort @parsed_json.inspect


# DELETE carrier_services
	if @carrier_services.present? 
		uri = URI.parse("https://" + shop_session.url + "/admin/carrier_services/" + @carrier_services.to_s + ".json")
		response = Net::HTTP.new(uri.host, uri.port)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Delete.new(uri.path, initheader = {'Content-Type' =>'application/json', 'X-Shopify-Access-Token' => shop_session.token})
		http.request(request)
		response = http.request(request)
	end
	
else	

# NEW carrier_services
request_params =  {
      carrier_service:{
			    name: "Aramex",
			    callback_url: "https://shipify.aramex.com/checkout",
			    service_discovery: true
		      }    
}

uri = URI.parse("https://" + shop_session.url + "/admin/carrier_services.json")
response = Net::HTTP.new(uri.host, uri.port)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'X-Shopify-Access-Token' => shop_session.token})
request.body = request_params.to_json
http.request(request)
response = http.request(request)
#abort JSON.parse(response.body).inspect	
logger.info "#{Time.now}  #{shop_session.url} NEW carrier_services #{JSON.parse(response.body).inspect}"
end



		#if @is_aramex == false
		if params[:user][:auto].nil? || params[:user][:auto] == "0"	

			require 'uri'
			require 'net/http'
			require "json"
		
			# NEW fulfillment_service
				request_params =  {
					  fulfillment_service:{
								name: "Aramex",
								callback_url: "https://aramex.com",
								inventory_management: true,
								tracking_support: true,
								requires_shipping_method: false,
								format: "json"
							  }    
				}

				uri = URI.parse("https://" + shop_session.url + "/admin/fulfillment_services.json")
				response = Net::HTTP.new(uri.host, uri.port)
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
				request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'X-Shopify-Access-Token' => shop_session.token})
				request.body = request_params.to_json
				http.request(request)
				response = http.request(request)
				logger.info "#{Time.now}  #{shop_session.url} NEW fulfillment_service #{JSON.parse(response.body).inspect}"
	 	end






 #abort response.body.inspect

	
		@user = current_user
		if @user.update_attributes(params[:user])
			redirect_to root_url, notice: "Successfully updated Aramex information"
		else
			render 'edit'
		end
	end

	def default_domestic_product
		product_ar = []
		@user = current_user
    @domestic_product = @user.default_domestic_product_type
    @domestic_product.sort.each do |hash|
      Shipment.domestic_product_type_hash.sort.each do |k, v|  
        product_ar << [k, v] if hash == v    
      end
    end
   	render text: product_ar.to_json
  end

	def default_express_product
		product_ar = []
		@user = current_user
    @express_product = @user.default_international_product_type
    @express_product.sort.each do |hash|
      Shipment.express_product_type_hash.sort.each do |k, v|  
        product_ar << [k, v] if hash == v    
      end
  	end
		render text: product_ar.to_json
	end

	def default_domestic_services
		service_ar = []
		@user = current_user
    @domestic_services = @user.default_domestic_services
    @domestic_services.sort.each do |hash|
      Shipment.domestic_services_hash.sort.each do |k, v|  
        service_ar << [k, v] if hash == v    
      end
    end
   	render text: service_ar.to_json
	end

	def default_express_services
		service_ar = []
		@user = current_user
    @express_services = @user.default_international_services
    @express_services.sort.each do |hash|
      Shipment.express_services_hash.sort.each do |k, v|  
        service_ar << [k, v] if hash == v    
      end
  	end
		render text: service_ar.to_json
	end

end
