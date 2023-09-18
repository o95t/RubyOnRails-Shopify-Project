require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ShopifyAramex
  class Application < Rails::Application

    # Use SSL everywhere
#   config.force_ssl = true
#abort("Message goes here")
    # Shopify API connection credentials:
    if Rails.env.production?
      # config.shopify.api_key = "5ad29bcf23988c669b7359f418cf9440"   #this development API keys
      # config.shopify.secret = "805465e88cc15917580545d4f426e228"    #this development SECRET keys
      config.shopify.api_key = "d91958a2b25bc237c45bb9d3ba55c8d9" # this is aramex API keys
      config.shopify.secret = "104c56cedf88d9b7fc4a6b220ea264f0"  # this is new Secret key I had generated
      # config.shopify.secret = "f65fb66d067a07d8b71387e5d84ff959" # this is old secret key of Aramex
    else
      config.shopify.api_key = "d91958a2b25bc237c45bb9d3ba55c8d9"
      config.shopify.secret = "104c56cedf88d9b7fc4a6b220ea264f0"
      # config.shopify.secret = "926781beceff2e5903167d8636dc6b64" old shopify development key 
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # The WSDL files constants
    config.shipping_wsdl = (Rails.root.join('public', 'wsdl', 'shipping-services-api-wsdl.wsdl'))
    config.tracking_wsdl = (Rails.root.join('public', 'wsdl', 'shipments-tracking-api-wsdl.wsdl'))
    config.rate_calculator_wsdl = (Rails.root.join('public', 'wsdl', 'aramex-rates-calculator-wsdl.wsdl'))
    config.location_wsdl = (Rails.root.join('public', 'wsdl', 'location-api-wsdl.wsdl'))

    # The WSDL files constants(production)
    config.shipping_wsdl_production = (Rails.root.join('public', 'wsdl_production', 'shipping-services-api-wsdl.wsdl'))
    config.tracking_wsdl_production = (Rails.root.join('public', 'wsdl_production', 'shipments-tracking-api-wsdl.wsdl'))
    config.rate_calculator_wsdl_production = (Rails.root.join('public_production', 'wsdl', 'aramex-rates-calculator-wsdl.wsdl'))
    config.location_wsdl_production = (Rails.root.join('public', 'wsdl_production', 'location-api-wsdl.wsdl'))

  end
end
