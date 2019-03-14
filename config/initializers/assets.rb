# Enable the asset pipeline
Rails.application.config.assets.enabled = true

# Version of your assets, change this if you want to expire all your assets
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
Rails.application.config.assets.precompile += %w(
  calendars.js
  chosen.css
  chosen.jquery.min.js
  jquery-ui.css
  jquery.ui.timepicker.addon.js
  refinery/calendar.css
)
