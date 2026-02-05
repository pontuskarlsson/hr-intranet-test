# Be sure to restart your server when you modify this file.

if ENV['REDIS_HOST'].present? || ENV['REDIS_URL'].present?
  # Use Redis for session storage when available
  redis_config = if ENV['REDIS_URL'].present?
    ENV['REDIS_URL']
  else
    { host: ENV['REDIS_HOST'], port: ENV.fetch('REDIS_PORT', 6379).to_i, db: 0 }
  end

  Rails.application.config.session_store :redis_store, {
      servers: [redis_config],
      key: Rails.env.production? ? "_happy_rabbit_session" : "_hr_#{Rails.env}_session",
      domain: :all
  }
else
  # Fallback to cookie-based sessions (works without Redis)
  Rails.application.config.session_store :cookie_store,
    key: Rails.env.production? ? "_happy_rabbit_session" : "_hr_#{Rails.env}_session",
    domain: :all
end
