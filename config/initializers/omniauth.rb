Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :xero_oauth2, ENV['XERO_CLIENT_ID'], ENV['XERO_CLIENT_SECRET'],
           redirect_uri: "#{Rails.env.development? ? 'http://localhost:5000' : 'https://portal.happyrabbit.com'}/auth/xero_oauth2/callback",
           scope: 'openid profile email files accounting.transactions accounting.transactions.read accounting.reports.read accounting.journals.read accounting.settings accounting.settings.read accounting.contacts accounting.contacts.read accounting.attachments accounting.attachments.read offline_access'

  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']

end
