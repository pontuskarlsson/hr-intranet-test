module Refinery
  module QualityAssurance
    module Admin
      class DefectsController < ::Refinery::AdminController

        crudify :'refinery/quality_assurance/defect'

        private

        # Only allow a trusted parameter "white list" through.
        def inspection_params
          params.require(:defect).permit(:category_code, :category_name, :defect_code, :defect_name)
        end
      end
    end
  end
end
