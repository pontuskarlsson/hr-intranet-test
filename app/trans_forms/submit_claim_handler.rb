class SubmitClaimHandler < TransForms::FormBase
  set_main_model :expense_claim

  validates :expense_claim,     presence: true
  validate do
    errors.add(:expense_claim, 'Can not be submitted') unless expense_claim.try(:submittable?)
  end

  transaction do



  end

end
