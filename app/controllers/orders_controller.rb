class OrdersController < ApplicationController

	before_filter :valid_shopify_session, :logged_in_user

	around_filter :shopify_session

	# The method to display the /orders route
	def show
		# Check whether the shop and id parameter are passed. Will be passed by Shopify for all valid requests
		if params[:shop].blank? or (params[:id].blank? and params[:app_order_id].blank?)
			flash[:error] = "Invalid request"
			redirect_to root_url
		end

		unless params[:shop] == current_user.shop_url
			flash[:error] = "Shop URLs do not match"
			redirect_to root_url
		end

		if params.has_key? :app_order_id
			#  Retrieve the shopify order id from this record
			shopify_order_id = ShipmentStore.find(params[:app_order_id]).order_id
			@order = ShopifyAPI::Order.find(shopify_order_id)
		else
			# Get the order directly from the Shopify API 
			@order = ShopifyAPI::Order.find(params[:id])
		end

		# Redirect to root if the order is not retrieved from Shopify
		if @order.nil?
			flash[:error] = "There was an error in retrieving the order from Shopify. Try later or contact support"
			redirect_to root_url
		else
		
#my comment
			unless defined?(@order.shipping_address)
				@order_shipping_address = false
			else
				@order_shipping_address = @order.shipping_address
			end

			unless defined?(@order.customer)
				@order_customer_email = false
			else
				@order_customer_email = @order.customer.email
			end

			unless defined?(@order.customer.email)
				@order_customer_email = false
			else
				@order_customer_email = @order.customer.email
			end
#my comment		
		
#			@shipping_address = Address.from_order(@order.shipping_address, @order.customer.email)

			@shipping_address = Address.from_order(@order_shipping_address, @order_customer_email)
			
			# Check if this order is already shipped via Aramex
			@shipment_records = ShipmentStore.where(order_id: @order.id)
		end
	end

	def search_by_order_number
		shopify_orders = ShopifyAPI::Order.find(:all, params: { name: params["order_number"]})
		if shopify_orders.blank?
			flash[:error] = "Cannot find an order with this order number"
			redirect_to root_url
		else
			redirect_to orders_path(shop: current_user.shop_url, id: shopify_orders.first.id )
		end
	end

	def search_by_awb
		order = ShipmentStore.find_by_awb(params[:awb])
		if order.nil?
			flash[:error] = "Cannot find an order with this Waybill Number"
			redirect_to root_url
		else
			redirect_to orders_path(shop: current_user.shop_url, app_order_id: order.id )
		end
	end
	
	def search_by_fullfil
			if defined?(params[:fulfilled])
			#abort params[:fulfilled].inspect
			redirect_to root_url( fulfilled: params[:fulfilled] )
			end
	end	
end
