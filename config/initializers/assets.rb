# Enable the asset pipeline
Rails.application.config.assets.enabled = true

# Version of your assets, change this if you want to expire all your assets
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
Rails.application.config.assets.precompile += %w(
  calendars.js
  chosen.css
  chosen.jquery.min.js
  foundation_and_overrides
  foundation_and_overrides_portal
  jquery-ui.css
  jquery.ui.timepicker.addon.js
  public.js
  public.scss
  refinery/backend.scss
  refinery/calendar.css
)
