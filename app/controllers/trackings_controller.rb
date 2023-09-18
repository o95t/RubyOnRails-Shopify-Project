class TrackingsController < ApplicationController

	before_filter :valid_shopify_session, :logged_in_user

	around_filter :shopify_session

	def index
		count_of_trackings = 10
		per_page = 2
		params[:page] ||= 1
		@count_of_pages = count_of_trackings/per_page
		@count_of_pages += 1 if count_of_trackings%per_page != 0

	@trackings = [
		{order_number: 1111, location: "Amman", last_status: "paid", updated_date: "3/12/2019", shipment_number: "124141", status: "124141"}, 
		{order_number: 2222, location: "Lviv", last_status: "good", updated_date: "5/12/2019", shipment_number: "124155", status: "124166"}, 
	]
	@trackings.to_json
	end	

	def show
		@shipment_store = ShipmentStore.find(params[:shipment_store_id])

		@message_hash = { client_info: current_user.savon_hash  }
		@message_hash.merge!  @shipment_store.tracking_hash

		# @tracking_wsdl_url = request.protocol + request.host_with_port + '/assets/shipments-tracking-api-wsdl.wsdl'

		tracking_client = Savon.client(pretty_print_xml: true) do
			wsdl "#{ShopifyAramex::Application.config.tracking_wsdl}"
			convert_request_keys_to :camelcase
		end

 		@response = tracking_client.call(:track_shipments, message: @message_hash)

 		# debugger if Rails.env.development?

 		# Check if the reponse has errors
 		if @response.body[:shipment_tracking_response][:has_errors]
 			@has_error = true
 			flash[:error] = "There was some error. Try again. Contact Aramex if the error persists."
 			logger.error "#{Time.now} -- Error in trackings#show --- #{@response.body[:shipment_tracking_response].to_yaml}"
 			redirect_to root_url
 		else
 			# Response is successful 
 			@tracking_array = @response.body[:shipment_tracking_response][:tracking_results][:key_value_ofstring_array_of_tracking_resultm_f_akxlp_y][:value][:tracking_result]
 		end 
	end
end
