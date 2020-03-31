Refinery::Marketing::Contact.class_eval do

  has_one :company,       class_name: '::Refinery::Business::Company',
                          dependent: :nullify
  belongs_to :owner,      class_name: '::Refinery::Business::Company',
                          optional: true

  def self.find_by_xero_id(account, xero_id)
    if account.organisation == ::Refinery::Business::Account::HRL
      find_by xero_hr_id: xero_id

    elsif account.organisation == ::Refinery::Business::Account::HRTL
      find_by xero_hrt_id: xero_id
    end
  end

  def xero_id_for_account(account)
    if account.organisation == ::Refinery::Business::Account::HRL
      xero_hr_id

    elsif account.organisation == ::Refinery::Business::Account::HRTL
      xero_hrt_id
    end
  end

  def set_xero_id_for_account(account, xero_id)
    if account.organisation == ::Refinery::Business::Account::HRL
      self.xero_hr_id = xero_id

    elsif account.organisation == ::Refinery::Business::Account::HRTL
      self.xero_hrt_id = xero_id
    end
  end

end
