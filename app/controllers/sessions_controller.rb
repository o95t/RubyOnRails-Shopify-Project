class SessionsController < ApplicationController
  def new
    
render layout: "unauthorized"
    authenticate if params[:shop].present?
  end

  # Take the shop url and pass it on to Shopify
  # This is just the login form taking the shop url. It calls authenticate which will in turn
  # sanitize the shop url and call Shopify
  def create
    authenticate
  end

  # The action called by the Shopify Omniauth callback
  def show
    Rails.logger.info "#{Time.now} Line 1 of sessions#show"
    if response = request.env['omniauth.auth']
      Rails.logger.info "#{Time.now} Got response from omniauth hash"
      sess = ShopifyAPI::Session.new(params[:shop], response['credentials']['token'])
      session[:shopify] = sess
      flash[:success] = "Authenticated with Shopify"

      # We need to check whether we have a user account for this shop. If yes, continue. If no.
      # redirect to new_user

      Rails.logger.info "#{Time.now} Finding user by shop_url"
      user =  User.find_by_shop_url sess.url

      Rails.logger.info "#{Time.now} Found user -- #{user.to_yaml}"
      # debugger if Rails.env.development?
      
      unless user.nil?
        login(user)
        # debugger if Rails.env.development?
        redirect_to return_address
      else
        redirect_to new_user_url
      end

    else
      flash[:error] = "Could not log in to Shopify store."
      redirect_to :action => 'new'
    end
  end

  # The action called on logout
  def destroy
    logout # Call the SessionsHelper method to clear current_user and remember_cookie
    session[:shopify] = nil
    flash[:notice] = "Successfully logged out."

    redirect_to :action => 'new'
  end

  protected

  def authenticate
    if shop_name = sanitize_shop_param(params)
	
	
	
	
	
	

      redirect_to "/auth/shopify?shop=#{shop_name}"
    else
      redirect_to return_address
    end
  end

  def return_address
    session[:return_to] || root_url
  end

  def sanitize_shop_param(params)
    return unless params[:shop].present?
    
    name = params[:shop].to_s.strip
    name += '.myshopify.com' if !name.include?("myshopify.com") && !name.include?(".")
    name.sub('https://', '').sub('http://', '')
  end
end