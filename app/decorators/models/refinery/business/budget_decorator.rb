module Refinery
  module Business

    # A constant containing the available quarters and their
    # corresponding range of months that they represent.
    QUARTERS = {
        'Q1' => 1..3,
        'Q2' => 4..6,
        'Q3' => 7..9,
        'Q4' => 10..12
    }

    Budget.class_eval do

      # A method to display which quarter the Budget is in.
      def quarter
        if from_date.present?
          QUARTERS.detect { |_,v| v === from_date.month }[0]
        end
      end

      def year
        if from_date.present?
          from_date.year
        end
      end

    end
  end
end
