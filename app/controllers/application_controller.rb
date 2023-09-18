class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include PickupsHelper

  # include PickupsHelper
  # See http://railscasts.com/episodes/106-time-zones-revised for reasons behind using around_filter
  # around_filter :user_time_zone, if: :current_user

  # Using UTC time. Getting input in UTC time itself. Not using timezone

  # Calculates total quantity for a given Shopify order
  # @note Used in both shipments and rate-calculator controller 
  # @param order [Hash] Shopify order hash
  # @return [String] The total quantity for this order
  def calculate_total_quantity_from_order(order)
	quantity = 0

	order.line_items.each do |item|
		quantity += item.quantity
	end

	quantity
  end

  private

 #  def user_time_zone(&block)
	# Time.use_zone(current_user.time_zone, &block)
 #  end

end