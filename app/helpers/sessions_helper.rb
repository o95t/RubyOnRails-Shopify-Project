module SessionsHelper

  # Logins the user by setting a cookie and sets current_user variable.
  # @param user [User] the user to be logged in
  def login(user)
    cookies.permanent.signed[:remember_token] = user.remember_token
    current_user = user
    # debugger if Rails.env.development?
  end

  # Tells whether we have a logged in user
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user
  def logout
    current_user = nil
    cookies.delete(:remember_token)
  end

  # Sets the current user
  # @param user [User] The user to be set as current_user
  def current_user=(user)
    @current_user = user
  end

  # Returns the current_user
  # @return current_user [User] The current_user
  def current_user
    # debugger if Rails.env.development?
    @current_user ||= User.find_by_remember_token(cookies.signed[:remember_token])
  end

  #  Tells whether the current_user is equal to the given user
  # @param user [User] The user to be checked
  # @return true [Boolean] If user is current_user
  # @return false [Boolean] If user is not current_user
  def current_user?(user)
    user == current_user
  end

  # Redirects back to the session :return_to path or the default
  # @param default [String] The default return path
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # Stores the request path in session
  def store_location
    session[:return_to] = request.fullpath
  end

  # Check for whether user is logged in. Calls #{store_location} and redirects to
  # root if not logged in.
  def logged_in_user
    # debugger if Rails.env.development?
    unless logged_in?
      store_location
      redirect_to login_path, notice: "Please sign in"
    end
  end

   # Check whether the shopify session is set
  def valid_shopify_session
    if session[:shopify].nil?
      flash[:error] = "Your Shopify session is invalid. Please logout and login again."
      redirect_to login_path
    end
  end

end
