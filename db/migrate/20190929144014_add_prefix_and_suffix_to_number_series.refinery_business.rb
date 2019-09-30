# This migration comes from refinery_business (originally 21)
class AddPrefixAndSuffixToNumberSeries < ActiveRecord::Migration

  def change
    add_column :refinery_business_number_series, :prefix, :string, null: false, default: ''
    add_column :refinery_business_number_series, :suffix, :string, null: false, default: ''
    add_column :refinery_business_number_series, :number_of_digits, :integer, null: false, default: 5
  end

end
