Refinery::Marketing::Contact.class_eval do

  has_one :company,       class_name: '::Refinery::Business::Company',
                          dependent: :nullify
  belongs_to :owner,      class_name: '::Refinery::Business::Company',
                          optional: true

  def self.find_by_xero_id(account, xero_id)
    if account.organisation == 'Happy Rabbit Limited'
      find_by xero_hr_id: xero_id

    elsif account.organisation == 'Happy Rabbit Trading Limited'
      find_by xero_hrt_id: xero_id
    end
  end

end
