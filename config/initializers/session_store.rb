# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_portal_session', domain: :all

Rails.application.config.session_store :redis_store, {
    servers: [
        { host: ENV['REDIS_HOST'], port: 6379, db: 0 },
    ],
    key: Rails.env.production? ? "_happy_rabbit_session" : "_hr_#{Rails.env}_session",
    domain: :all
}
