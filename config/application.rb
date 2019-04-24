require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Coesapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.i18n.default_locale = :es
    config.i18n.fallbacks = [I18n.default_locale]
    config.assets.enabled = true
    config.assets.precompile += %w( application.css.scss ) 
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.action_mailer.default_options = {authentication: 'plain'}

    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address: Rails.application.secrets.address,
      port: 25,
      # domain: Rails.application.secrets.domain_name,
      user_name: Rails.application.secrets.email_provider_username,
      password: Rails.application.secrets.email_provider_password,
      openssl_verify_mode: :none,
      authentication:       :plain,
      enable_starttls_auto: true
      # tls: :none
    }

  end
end
