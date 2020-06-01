module Refinery
  module Addons
    class ReportRenderer

      def initialize(locals = {})
        @locals = locals
      end

      def set_options(options)
        @options = options
      end

      def options
        WickedPdf.config.merge(@options || {})
      end

      def render(template)
        pdf_html = view.render(template)

        # use wicked_pdf gem to create PDF from the doc HTML
        WickedPdf.new.pdf_from_string(pdf_html, options)
      end

      private

      def view
        @view ||= ActionView::Base.new.tap do |av|
          av.view_paths = ActionController::Base.view_paths

          av.class_eval do
            include Rails.application.routes.url_helpers
            include ApplicationHelper
          end

          @locals.each_pair do |k, v|
            av.instance_eval do
              instance_variable_set(:"@#{k}", v)
            end
          end
        end
      end

    end
  end
end
