Refinery::Business::BillingAccount.class_eval do

  acts_as_target email: :email_addresses,
                 email_allowed: ->(billing_account, notifiable, key) { billing_account.email_addresses.present? },
                 batch_email_allowed: ->(billing_account, key) { billing_account.email_addresses.present? }

end
