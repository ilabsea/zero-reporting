require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load unless Rails.env.production?

ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module ZeroReporting
  class Application < Rails::Application

    config.middleware.use Rack::Attack

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = ENV['TIME_ZONE']

    config.autoload_paths += %W( #{config.root}/lib #{config.root}/app/presenters)
    config.autoload_paths += %W(#{Rails.root}/lib/backup)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_job.queue_adapter = :sidekiq
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.default_url_options = { host: ENV['HOST'] }
    config.action_mailer.default_url_options = { :host => ENV['HOST'] }
    config.action_mailer.asset_host = ENV['HOST']

    if Rails.env.production?
      # Sprockets
      initializer 'setup_asset_pipeline', :group => :all  do |app|
        # We don't want the default of everything that isn't js or css, because it pulls too many things in
        app.config.assets.precompile.shift

        # Explicitly register the extensions we are interested in compiling
        app.config.assets.precompile.push(Proc.new do |path|
          File.extname(path).in? [
            '.html', '.erb', '.haml',                 # Templates
            '.png',  '.gif', '.jpg', '.jpeg',         # Images
            '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
          ]
        end)
      end
    end

  end
end
