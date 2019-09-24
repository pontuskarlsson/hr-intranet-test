Refinery::Marketing::Contact.class_eval do

  # Associations
  belongs_to :xero_hr_contact,    class_name: '::Refinery::Employees::XeroContact',
                                  primary_key: :guid,
                                  foreign_key: :xero_hr_id
  belongs_to :xero_hrt_contact,   class_name: '::Refinery::Employees::XeroContact',
                                  primary_key: :guid,
                                  foreign_key: :xero_hrt_id

end
