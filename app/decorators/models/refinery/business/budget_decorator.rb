Refinery::Business::Budget.class_eval do

  # A method to display which quarter the Budget is in.
  def quarter
    if from_date.present?
      "Q#{ from_date.month / 3 + 1 }"
    end
  end

end
