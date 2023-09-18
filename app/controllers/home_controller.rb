class HomeController < ApplicationController
 
  # Do we need a
  before_filter :valid_shopify_session, :logged_in_user, :except => [:index] 

  # This is Shopify's filter for controlling auth
  around_filter :shopify_session
  
  # The index method for the root_url
  def index
    # Get latest 25 orders - latest order first 
    # @return [Array<Hash>] Latest orders from Shopify API
    # Rails.logger.info "A line before orders"
	#
	#abort current_user.inspect


	# NEW carrier_services
	
	uuu = ShopifyAPI::Webhook.create(address: "https://shopify.aramex.com/webhook", topic: "app/uninstalled", format: "json")
	#	logger.info "#{Time.now} Found user webhook111 #{uuu.inspect}"
	
	
	#	require 'uri'
	#	require 'net/http'
	#	require "json"


	# GET carrier_services
	#	uri = URI.parse("https://" + shop_session.url + "/admin/webhooks.json")
	#	response = Net::HTTP.new(uri.host, uri.port)
	#	http = Net::HTTP.new(uri.host, uri.port)
		#http.use_ssl = true
	#	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	#	request = Net::HTTP::Get.new(uri.path, initheader = {'Content-Type' =>'application/json', 'X-Shopify-Access-Token' => shop_session.token})
	#	http.request(request)
	#	response = http.request(request)
	#	@parsed_json = JSON.parse(response.body)

	#logger.info @parsed_json.inspect
	
	

	
	
    @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 25, :order => "created_at DESC" })
    # Rails.logger.info "A line after orders"
  end  
end