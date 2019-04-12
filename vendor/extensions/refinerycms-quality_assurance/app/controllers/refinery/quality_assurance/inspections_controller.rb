module Refinery
  module QualityAssurance
    class InspectionsController < ::ApplicationController

      before_action :find_all_inspections
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

      def show
        @inspection = Inspection.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @quality_assurance in the line below:
        present(@page)
      end

    protected

      def find_all_inspections
        @inspections = Inspection.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/quality_assurance").first
      end

    end
  end
end
