class AddCompanyReferenceToProjects < ActiveRecord::Migration

  def change
    add_column :refinery_business_projects, :company_reference, :string
    add_index :refinery_business_projects, :company_reference
  end

end
