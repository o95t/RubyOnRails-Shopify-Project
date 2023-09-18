class RateCalculatorController < ApplicationController

	before_filter :valid_shopify_session, :logged_in_user

	around_filter :shopify_session

	def select_shipment_type
		@order_id = params[:order_id]
	end

	def new


		# Get the order from order id
		@countries = aramex_country_ar
		@order = ShopifyAPI::Order.find(params[:order_id])
		
#my comment	
			unless @order.respond_to? :shipping_address
				@order_shipping_address = false
			else
				@order_shipping_address = @order.shipping_address
			end

			unless @order.respond_to? :customer
				@order_customer_email = false
			else
				@order_customer_email = @order.customer.email
			end
#my comment	

		
		@payment_type = params[:payment_type]
		@rate_calculator_form = RateCalculatorForm.new(nil)

		@rate_calculator_form.payment_type = @payment_type

		# Set values for origin

		case @rate_calculator_form.payment_type
		when "P"
			@origin_address = current_user.address
#abort @order.shipping_address.inspect
			#@destination_address = Address.from_order(@order.shipping_address, @order.customer.email)
			@destination_address = Address.from_order(@order_shipping_address, @order_customer_email)

		when "C"
			#@origin_address = Address.from_order(@order.shipping_address, @order.customer.email)
			@origin_address = Address.from_order(@order_shipping_address, @order_customer_email)
			@destination_address = current_user.address
		when "3"
			#@destination_address = @order.shipping_address
			@destination_address = @order_shipping_address
			# @third_party_address = @order.customer.default_address
		end

		# Lets set the origin address to origin in case of P and destination in case of C
		# In case of 3, origin address will be blank.
		unless @rate_calculator_form.payment_type == "3"
			@rate_calculator_form.origin_address_line1 = @origin_address.address1
			@rate_calculator_form.origin_address_line2 = @origin_address.address2
			@rate_calculator_form.origin_city = @origin_address.city
			@rate_calculator_form.origin_post_code = @origin_address.zip
			# @rate_calculator_form.origin_state_code = @origin_address.province_code
			@rate_calculator_form.origin_country_code = @origin_address.country_code
		else
			@rate_calculator_form.origin_address_line1 = ""
			@rate_calculator_form.origin_address_line2 = ""
			@rate_calculator_form.origin_city = ""
			@rate_calculator_form.origin_post_code = ""
			# @rate_calculator_form.origin_state_code = ""
			@rate_calculator_form.origin_country_code = ""
		end

		# Set values for destination address
		

#my comment	
			if @destination_address.respond_to? :address1
				@destination_address_address1 = @destination_address.address1
			else
				@destination_address_address1 = false
			end
			if @destination_address.respond_to? :address2
				@destination_address_address2 = @destination_address.address2
			else 	
				@destination_address_address2 = false
			end
			if @destination_address.respond_to? :city
				@destination_address_city = @destination_address.city
			else
				@destination_address_city = false
			end
			if @destination_address.respond_to? :zip
				@destination_address_zip = @destination_address.zip
			else
				@destination_address_zip = false	
			end		
			if @destination_address.respond_to? :country_code
				@destination_address_country_code = @destination_address.country_code
			else	
				@destination_address_country_code = false
			end					
#my comment				
		
		
		#@rate_calculator_form.destination_address_line1 = @destination_address.address1
		@rate_calculator_form.destination_address_line1 = @destination_address_address1

		#@rate_calculator_form.destination_address_line2 = @destination_address.address2
		@rate_calculator_form.destination_address_line2 = @destination_address_address2		
		
		#@rate_calculator_form.destination_city = @destination_address.city
		@rate_calculator_form.destination_city = @destination_address_city
		
		#@rate_calculator_form.destination_post_code = @destination_address.zip
		@rate_calculator_form.destination_post_code = @destination_address_zip
		# @rate_calculator_form.destination_state_code = @destination_address.province_code
		
		#@rate_calculator_form.destination_country_code = @destination_address.country_code
		@rate_calculator_form.destination_country_code = @destination_address_country_code

		# To control what options product type select shows. Will only select the right
		# value in case of rate_calculator_form types P and C
		if @rate_calculator_form.origin_country_code == @rate_calculator_form.destination_country_code
			@rate_calculator_form.product_group = "DOM"
			@product_type_hash = Shipment.domestic_product_type_hash
		else
			@rate_calculator_form.product_group = "EXP"
			@product_type_hash = Shipment.express_product_type_hash
		end

		# Set the description from the line_items received from Shopify
		@description = ""
		@order.line_items.each do |item|
			@description += item.name + ", "
		end

		@rate_calculator_form.description_of_goods = @description

		@rate_calculator_form.num_of_pieces = calculate_total_quantity_from_order(@order)
		@rate_calculator_form.actual_weight = (@order.total_weight.to_f)/1000 # shopify returns wight in grams

		# debugger
	end

	def create
		@has_error = false
		@aramex_error_msg = ""

		@rate_calculator_form = RateCalculatorForm.new(params[:rate_calculator_form])

		@rate_calculator_form.goods_origin_country = @rate_calculator_form.origin_country_code

		@order_id = params[:rate_calculator_form][:order_id]

		# debugger if Rails.env.development?
		


		if @rate_calculator_form.valid?
			@message_hash = { client_info: current_user.savon_hash  }
			@message_hash.merge!  @rate_calculator_form.savon_hash
		#abort @message_hash.inspect
			rate_calculator_client = Savon.client do
 				wsdl "#{ShopifyAramex::Application.config.rate_calculator_wsdl.to_s}"
 				convert_request_keys_to :camelcase
 			end

 			@response = rate_calculator_client.call(:calculate_rate, message: @message_hash)

 			# Check if the response has errors
 			if @response.body[:rate_calculator_response][:has_errors]
 				@has_error = true
 				@notifications = @response.body[:rate_calculator_response][:notifications][:notification]

 				# When there is only one error, response gives us a hash but for multiple errors, we
 				# get an array of hashes. So, we convert hash in to array of hashes
 				if @notifications.class == {}.class
 					@notifications = [] << @notifications
 				end
 				@notifications.each do |notification|
 					@aramex_error_msg += "#{notification[:code]}  #{notification[:message]} \n"
 				end
 			else
 				@currency_code = @response.body[:rate_calculator_response][:total_amount][:currency_code]
 				@amount = @response.body[:rate_calculator_response][:total_amount][:value]
			end
		else
			@has_error = true
		end
		if @has_error
			flash.now[:error] = "Error in calculating the rate. Please try again.
							<p><strong>#{@aramex_error_msg}</strong></p>"
			if @rate_calculator_form.product_group = "DOM"
			 	@product_type_hash = Shipment.domestic_product_type_hash
			else
				@product_type_hash = Shipment.express_product_type_hash
			end

			@order = ShopifyAPI::Order.find(@order_id)

			render 'new'
		end
		# debugger
	end

end
