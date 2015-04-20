module Refinery
  module Business
    class BudgetForm < ApplicationTransForm
      set_main_model :budget, class_name: '::Refinery::Business::Budget', proxy: { attributes: :all }

      attribute :budget_items_attributes,     Hash

      # Method needed for FormHelpers to use +fields_for+ method.
      delegate :budget_items, to: :budget

      transaction do
        # Attributes that can be assigned directly
        %w(customer_name description from_date to_date comments).each do |attr|
          budget.send("#{attr}=", send(attr))
        end

        # Tries to assign a contact based on +customer_name+. Assigns nil if not found
        budget.customer_contact = ::Refinery::Marketing::Contact.find_by_name(customer_name)

        # Saves the Budget here so that it has an +id+ attribute that BudgetItem can associate to
        budget.save!

        update_budget_items!
      end

      private
      def update_budget_items!
        # Loops through the supplied attributes for BudgetItems and creates if it's valid
        each_nested_hash_for budget_items_attributes do |attr|
          attr['margin'] = attr.delete('margin_percent').to_f / 100.0 if attr.has_key?('margin_percent')

          if attr.has_key?('id')
            budget_item = budget.budget_items.find(attr['id'])
            if attr['_destroy'] == '1'
              budget_item.destroy
            else
              budget_item.attributes = attr
              budget_item.save!
            end
          elsif valid_item_attr?(attr)
            budget_item = budget.budget_items.build(attr)
            budget_item.save!
          end
        end
      end

      # A method to make sure that values are present before trying to create the BudgetItem.
      # This is because there are a lot of empty rows rendered in the view, but if they only
      # contain blank or zero values, then they should not be created.
      def valid_item_attr?(attr)
        attr.values.any? { |v| v.present? && v != '0' && v != '0.0' && !(v.respond_to?(:zero?) && v.zero?) }
      end

    end
  end
end
