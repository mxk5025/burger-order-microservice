require_relative 'boot'
# Pick the frameworks you want: 
require "active_job/railtie"
require "action_cable/engine"
require "action_controller/railtie" 
require "action_mailer/railtie" 
require "action_view/railtie" 
require "rails/test_unit/railtie"
require "active_storage/engine"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrderPlacementUI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
