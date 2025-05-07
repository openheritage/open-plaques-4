module OpenPlaques
  class Application < Rails::Application
    #  config.i18n.enforce_available_locales = false
    #  config.i18n.available_locales = [:'en-GB', :fr, :en, :ru]
    config.i18n.available_locales = [ :'en-GB', :en ]
    config.i18n.default_locale = :'en-GB'
    config.i18n.fallbacks = [ :en ]
  end
end
