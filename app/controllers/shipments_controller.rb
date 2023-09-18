class ShipmentsController < ApplicationController

	before_filter :valid_shopify_session, :logged_in_user

	around_filter :shopify_session, :except => 'welcome'

	def index
		count_of_orders = ShopifyAPI::Order.count
		per_page = 2
		params[:page] ||= 1
		@count_of_pages = count_of_orders/per_page
		@count_of_pages += 1 if count_of_orders%per_page != 0
		@orders   = ShopifyAPI::Order.find(:all, :params => {:limit => per_page, :page => params[:page], :order => "created_at DESC" })

		if params[:order_number]
			@orders = ShopifyAPI::Order.find(:all, params: { name: params[:order_number]})
			@count_of_pages = 1
		end

		if params[:fulfillment_status]
			@orders = ShopifyAPI::Order.find(:all, params: { fulfillment_status: params[:fulfillment_status]})
			@count_of_pages = 1
		end	

		if params[:financial_status]
			@orders = ShopifyAPI::Order.find(:all, params: { financial_status: params[:financial_status]})
			@count_of_pages = 1
		end	


	end

	def search_by_order_number
		shopify_orders = ShopifyAPI::Order.find(:all, params: { name: params["order_number"]})
		if shopify_orders.blank?
			render json: {error: "Cannot find an order with this order number"}, status: 404
		else
			render json: shopify_orders.first, status: 200
		end
	end

	def select_shipment_type
		@order_id = params[:order_id]
	end


	def new
		return @shipment = Shipment.new unless params[:order_id]
		#abort current_user.auto.inspect	
		@countries = aramex_country_ar
		# Get the order from order id
		@order = ShopifyAPI::Order.find(params[:order_id])
		
		#my comment
		unless @order.respond_to? :shipping_address
				flash[:error] = "No customer data! Go back and fill in the information about the customer on Shopify side"
				return  redirect_to(:back)
		end
		
		
		@payment_type = params[:payment_type]

		# Redirect to root if order id and payment_type already exist
		if ShipmentStore.where(order_id: @order.id, payment_type: @payment_type).blank?
			@shipment = Shipment.new
# My comment	
		@shipment.location_id = @order.location_id
		
#logger.info "#{Time.now}  #{shop_session.url}  Order info #{@order.inspect}"
		
		
	uri = URI.parse("https://" + shop_session.url + "/admin/locations.json")
	response = Net::HTTP.new(uri.host, uri.port)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.path, initheader = {'Content-Type' =>'application/json', 'X-Shopify-Access-Token' => shop_session.token})
	http.request(request)
	response = http.request(request)
	@parsed_json = JSON.parse(response.body)
	
	
	
#  if current_user.auto.nil? || current_user.auto == "0"	
# 	@is_aramex = false
# 	if @parsed_json["locations"].present?
# 		@parsed_json["locations"].each do |doc|
# 			if doc["name"] == "Aramex"
# 				@is_aramex = true
# 				@shipment.location_id = doc["id"]
# 			end
# 		 end
# 	end
	
# else
# 	if @parsed_json["locations"].present?
# 		@parsed_json["locations"].each do |doc|
# 			if doc["name"] != "Aramex"
# 				@shipment.location_id = doc["id"]
# 			end
# 		 end
# 	end
# end





#abort 	@order.inspect
			@shipment.payment_type = @payment_type

			# Set values for shipper

			case @shipment.payment_type
			when "P"

			@shipper_address = current_user.address
			
						begin
				
				

				
				
	
				@receiver_address = Address.from_order(@order.shipping_address, @order.customer.email)
				
				@receiver_address.reference = @order.reference
				@payment_options_hash = Shipment.shipper_payment_options_hash
rescue StandardError => e
					flash[:error] = "Shopify: Undefined 'Shipping Address' Data "	
				end
				
			when "C"
			begin
				@shipper_address = Address.from_order(@order.shipping_address, @order.customer.email)
                rescue => e
                    flash[:error] = "Shopify: Undefined 'Customer' Data"  
                end				
				@receiver_address = current_user.address
				@payment_options_hash = Shipment.consignee_payment_options_hash
			when "3"
				@receiver_address = Address.from_order(@order.shipping_address, @order.customer.email)
				@third_party_address = current_user.address
			
			end

			#debugger if Rails.env.development?

			#Shipment Reference
			@shipment.shipment_refer = params[:shipment_refer]

			# Lets set the shipper address to shipper in case of P and receiver in case of C
			# In case of 3, shipper address will be blank.
			unless @shipment.payment_type == "3"
			
			
					if(@shipper_address)
						@shipment.shipper_person_name = @shipper_address.first_name + ' ' + @shipper_address.last_name
						@shipment.shipper_company_name = @shipper_address.company
						@shipment.shipper_cellphone = @shipper_address.phone
						@shipment.shipper_email = @shipper_address.email
						@shipment.shipper_address_line1 = @shipper_address.address1
						@shipment.shipper_address_line2 = @shipper_address.address2
						@shipment.shipper_city = @shipper_address.city
						@shipment.shipper_post_code = @shipper_address.zip
						@shipment.shipper_country_code = @shipper_address.country_code
						@shipment.shipper_refer = @shipper_address.reference
					end	
			else
				@shipper_address = current_user.address
					if(@shipper_address)
						@shipment.shipper_person_name = @shipper_address.first_name + ' ' + @shipper_address.last_name
						@shipment.shipper_company_name = @shipper_address.company
						@shipment.shipper_cellphone = @shipper_address.phone
						@shipment.shipper_email = @shipper_address.email
						@shipment.shipper_address_line1 = @shipper_address.address1
						@shipment.shipper_address_line2 = @shipper_address.address2
						@shipment.shipper_city = @shipper_address.city
						@shipment.shipper_post_code = @shipper_address.zip
						@shipment.shipper_country_code = @shipper_address.country_code
						@shipment.shipper_refer = @shipper_address.reference
					else	
				@shipment.shipper_person_name = ""
				@shipment.shipper_company_name = ""
				@shipment.shipper_cellphone = ""
				@shipment.shipper_email = ""
				@shipment.shipper_address_line1 = ""
				@shipment.shipper_address_line2 = ""
				@shipment.shipper_city = ""
				@shipment.shipper_post_code = ""
				@shipment.shipper_country_code = ""
				@shipment.shipper_refer = ""
					end	

			end

			# Set values for receiver address


			
			
			
			
			# @shipment.receiver_person_name = @receiver_address.first_name.to_s + ' ' + @receiver_address.last_name.to_s 
			# @shipment.receiver_company_name = @receiver_address.company
			# @shipment.receiver_cellphone = @receiver_address.phone
			# @shipment.receiver_email = @order.customer.email
			# @shipment.receiver_address_line1 = @receiver_address.address1
			# @shipment.receiver_address_line2 = @receiver_address.address2
			# @shipment.receiver_city = @receiver_address.city
			# @shipment.receiver_post_code = @receiver_address.zip
			# @shipment.receiver_country_code = @receiver_address.country_code
			# @shipment.receiver_refer = @receiver_address.reference


			if @shipment.payment_type == "3"
				@shipment.third_party_person_name = @third_party_address.first_name.to_s + ' ' + @third_party_address.last_name.to_s
				@shipment.third_party_company_name = @third_party_address.company
				@shipment.third_party_cellphone = @third_party_address.phone
				#@shipment.third_party_email = @order.customer.email
				@shipment.third_party_email = @shipper_address.email
				@shipment.third_party_address_line1 = @third_party_address.address1
				@shipment.third_party_address_line2 = @third_party_address.address2
				@shipment.third_party_city = @third_party_address.city
				@shipment.third_party_post_code = @third_party_address.zip
				@shipment.third_party_country_code = @third_party_address.country_code
				
			end

			# debugger if Rails.env.development?
			# To control what options product type select shows. Will only select the right
			# value in case of shipment types P and C

			# Also takes in to account default product group
			if current_user.default_product_group.blank?
				# No default set
				# Set group based on receiver and shipper countries
				
				if @shipment.shipper_country_code == @shipment.receiver_country_code
					@shipment.product_group = "DOM"

				else
					@shipment.product_group = "EXP"
					
				end
			else
				@shipment.product_group = current_user.default_product_group
			end

			if @shipment.product_group ==  "DOM"
				@product_type_hash = Shipment.domestic_product_type_hash
				@selected_product_type = current_user.default_domestic_product_type
				# @selected_domestic_services = current_user.default_domestic_services
			elsif @shipment.product_group == "EXP"
				@product_type_hash = Shipment.express_product_type_hash
				@selected_product_type = current_user.default_international_product_type
				# @selected_international_services = current_user.default_international_services
			end

			if @payment_type == "P"
#abort 	@payment_type.inspect		
				@shipment.payment_options = current_user.default_prepaid_payment_option
			end

			# Set CODS service if product type is COD and group is DOM
			if @shipment.product_group == "DOM" and current_user.default_domestic_product_type == "CDA"
				@shipment.services = "CODS"
			end

			@description = ""
			@order.line_items.each do |item|
				@description += item.name + ", "
			end
#my_comment		
		if @order.payment_gateway_names.include? 'Cash on Delivery (COD)' 
			@shipment.cod = "CODS"

		else
			@shipment.cash_on_delivery = ""
			@shipment.cash_on_delivery = ""
			
			@shipment.cod = false
		end
			@shipment.description_of_goods = @description

			@shipment.num_of_pieces = calculate_total_quantity_from_order(@order)
			@shipment.actual_weight = (@order.total_weight.to_f)/1000 # shopify returns wight in grams

			@shipment.order_id = @order.id
			@shipment.order_number = @order.order_number

			@shipment.customs_value_amount = @shipment.cash_on_delivery = @shipment.insurance_amount = @shipment.collect_amount = 0
			
			if @order.gateway == "Cash on Delivery (COD)"
				@shipment.cash_on_delivery = @order.total_price
			else
				@shipment.cash_on_delivery = 0
			end
			
			@shipment.customs_currency_code = current_user.currency_code
			@shipment.cod_currency_code = current_user.currency_code
#my_comment 
if @shipment.product_group == "EXP"
    @shipment.customs_value_amount = @order.total_price
 
        else    
    @shipment.customs_value_amount = 0      
 
end
@shipment.shipment_refer1 = @order.name
@shipment.shipper_refer = @order.name
@shipment.receiver_refer = @order.name

if @shipment.payment_type == "3"
@shipment.cash_on_delivery = 0
end


		else
			flash[:error] = "The order #{@order.name} already has a shipment of type #{Shipment.shipping_information_hash.key(@payment_type)}."
			redirect_to orders_path(shop: current_user.shop_url, id: @order.id )
		end

		# debugger
	end

	def create

		@has_error = false
		@aramex_error_msg = ""

		@shipment = current_user.shipments.new(params[:shipment])
#My comment
@location_id = params[:shipment][:location_id]

		# Get the order from order id
		@order = ShopifyAPI::Order.find(@shipment.order_id)
		
			



		
		
from = "info@shopify.com"
to = @shipment.shipper_email
subject = 	"Shipment #{@order.name} was created by Aramex"
message = 	"Shipment was created by Aramex: <br />Order number #{@order.name}"		
#ContactMailer.send_contact(from,subject,message).deliver_now	

		

		# Automatically set the values for Good Origin Country, shippping and due datetime
		@shipment.goods_origin_country = @shipment.shipper_country_code
		@shipment.shipping_datetime = DateTime.now.utc.xmlschema
		@shipment.due_datetime = (DateTime.now + 7.days).utc.xmlschema

		# Initialize empty string values to all the third_party values unless payment type = 3

		if @shipment.payment_type == "P" or @shipment.payment_type == "C"
			@shipment.third_party_address_line1 =  @shipment.third_party_address_line2 =  @shipment.third_party_address_line3 =  @shipment.third_party_cellphone  =  @shipment.third_party_company_name =  @shipment.third_party_country_code =  @shipment.third_party_email =  @shipment.third_party_person_name =  @shipment.third_party_post_code = ""
		end

		# Set the other 2 account numbers to empty string
		case @shipment.payment_type
		when "P"
			@shipment.shipper_account_number = current_user.account_number
			@shipment.consignee_account_number = ""
			@shipment.third_party_account_number = ""
		when "C"
			@shipment.shipper_account_number = ""
			@shipment.consignee_account_number = current_user.account_number
			@shipment.third_party_account_number = ""
		when "3"
		# @shipment.shipper_account_number = ""
			@shipment.shipper_account_number = current_user.account_number
		@shipment.consignee_account_number = ""
			#@shipment.consignee_account_number = current_user.account_number
			@shipment.third_party_account_number = current_user.account_number
			@shipment.payment_options = "" # Set by form in case of P and C
			#@shipment.services = "CODS"
			
		end

		# debugger if Rails.env.development?

		if @shipment.valid?

			@message_hash = { client_info: current_user.shipping_savon_hash }
			@message_hash.merge!  @shipment.savon_hash(current_user)
		
#abort @message_hash.inspect

			# debugger if Rails.env.development?
			shipping_client = Savon.client(pretty_print_xml: true, ssl_verify_mode: :none) do
 				wsdl "#{ShopifyAramex::Application.config.shipping_wsdl.to_s}"
 				convert_request_keys_to :camelcase
 			end
logger.info "#{Time.now}  #{shop_session.url} Create Aramex Shipment request: #{@message_hash.inspect}"				
 			@response = shipping_client.call(:create_shipments, message: @message_hash)
logger.info "#{Time.now}  #{shop_session.url} Feadback Create Aramex Shipment request: #{@response.inspect}"		
 			# Check if the response has errors

 			if @response.body[:shipment_creation_response][:has_errors]
 				@has_error = true

 				# Different errors return different kind of response
 				if @response.body[:shipment_creation_response][:shipments].nil?
 					# Returned when login credentials are invalid
 					@notifications = @response.body[:shipment_creation_response][:notifications][:notification]
 				else
 					#@notifications = @response.body[:shipment_creation_response][:shipments][:processed_shipment][:notifications][:notification]
					#@notifications = @response.body[:shipment_creation_response][:notifications][:notification]
 					#abort(@notifications.inspect)
 					if @response.body[:shipment_creation_response][:notifications][:notification]
 						@notifications = @response.body[:shipment_creation_response][:notifications][:notification]
 					else
 						@notifications = @response.body[:shipment_creation_response][:shipments][:processed_shipment][:notifications][:notification]
 					end	

 				end


 				# When there is only one error, response gives us a hash but for multiple errors, we
 				# get an array of hashes. So, we convert hash in to array of hashes
 				if @notifications.class == {}.class
 					@notifications = [] << @notifications
 				end
 				@notifications.each do |notification|
 					@aramex_error_msg += "#{notification[:message]} <br />"
 				end
 			else
 				# Get the AWB id and the label URL from here
 				# debugger
 				@awb = @response.hash[:envelope][:body][:shipment_creation_response][:shipments][:processed_shipment][:id]
 				@label_url = @response.hash[:envelope][:body][:shipment_creation_response][:shipments][:processed_shipment][:shipment_label][:label_url]

 				# The shipment model is only to properly place all the values.
 				# We are only saving essential data in ShipmentStore
 				@shipment_store = current_user.shipment_stores.create(awb: @awb, label_url: @label_url, order_id: @shipment.order_id, order_number: @shipment.order_number, payment_type: @shipment.payment_type, shipment_refer: @shipment.shipment_refer, shipper_refer: @shipment.shipper_refer, receiver_refer: @shipment.receiver_refer)

 				if @shipment_store.id.nil?
 					@has_error = true
 					@aramex_error_msg += "Shipment was created on Aramax but we faced an error and couldn't save it <br /> #{@shipment_store.errors.full_messages}"
 				else
 					# Shipment was successful. Send a post request to the fulfillment api
 					@line_items = []
 					@order.line_items.each do |item|
 						@line_items << { id: item.id }
 					end
 	
logger.info "#{Time.now}  #{shop_session.url} Fulfillment send #{@location_id.inspect}"
 					@fulfillment = ShopifyAPI::Fulfillment.new(location_id: @location_id, order_id: @order.id, line_items: @line_items, tracking_number: @awb, notify_customer: true, tracking_company: "Aramex", tracking_url: "http://www.aramex.com/track-results-multiple.aspx?ShipmentNumber=#{@awb}")
 								
 					@fulfillment_response = @fulfillment.save
logger.info "#{Time.now}  #{shop_session.url} Fulfillment feadback #{@fulfillment.inspect}"

#@fulfillment.inspect
#abort @fulfillment_response.inspect
 					# debugger
 				end
			end
		else
			@has_error = true
		end

		if @has_error

			# debugger
			flash.now[:error] = "Error in creating your shipment. Please fix it and try again.
							<p><strong>#{@aramex_error_msg}</strong></p>"

			if @shipment.product_group == "DOM"
			 	@product_type_hash = Shipment.domestic_product_type_hash
			else
				@product_type_hash = Shipment.express_product_type_hash
			end

			# Set the payment options hash according to the payment type

			if @shipment.payment_type == "P"
				@payment_options_hash = Shipment.shipper_payment_options_hash
			elsif @shipment.payment_type == "C"
				@payment_options_hash = Shipment.consignee_payment_options_hash
			end

			render 'new'
		end
		# debugger
	end

	def print_label
		# Get the shipment store from the shipment store id passed in the URL
		@shipment_store = ShipmentStore.find(params[:shipment_store_id])

		# Check whether we have a ShipmentStore instance for this id. Otherwise
		# redirect to root_url
		if @shipment_store.nil?
			flash[:error] = "We did not find the shipment."
			redirect_to root_url
		end

		# Now check whether the shipment instance being accessed belongs to the current_user
		if @shipment_store.user == current_user
			shipping_client = Savon.client do
 				wsdl "#{ShopifyAramex::Application.config.shipping_wsdl.to_s}"
 				convert_request_keys_to :camelcase
 			end

 			@message_hash = { client_info: current_user.savon_hash  }
			@message_hash.merge!  @shipment_store.print_label_hash

 			@response = shipping_client.call(:print_label, message: @message_hash)

 			# debugger if Rails.env.development?

 			# Check if the response has errors
 			if @response.body[:label_printing_response][:has_errors]
 				flash[:error] = "There was some error in printing the label. Please contact Aramex Support"
 				redirect_to root_url
 			else
 				@label_url =  @response.body[:label_printing_response][:shipment_label][:label_url]
 				redirect_to @label_url
 			end
		else
			flash[:error] = "This shipment does not belong to you."
			redirect_to root_url
		end
	end

end
