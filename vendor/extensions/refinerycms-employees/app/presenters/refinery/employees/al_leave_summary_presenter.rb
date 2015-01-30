module Refinery
  module Employees
    # Knows how to build the html for a section. A section is part of the visible html, that has
    # content wrapped in some particular markup. Construct with the relevant options, and then
    # call wrapped_html to get the resultant html.
    #
    # The content rendered will usually be the value of fallback_html, unless an override_html
    # is specified. However, on rendering, you can elect not display sections that have no
    # override_html by passing in false for can_use_fallback.
    #
    # Sections may be hidden, in which case they wont display at all.
    class ALLeaveSummaryPresenter
      include ActionView::Helpers::TagHelper

      attr_reader :employee

      def initialize(employee)
        @employee = employee
      end

      def each_contract(&block)
        @employee.employment_contracts.order('start_date DESC').each do |employment_contract|
          yield employment_contract
        end
      end

      def each_year_for_contract(contract)

      end

    end
  end
end
