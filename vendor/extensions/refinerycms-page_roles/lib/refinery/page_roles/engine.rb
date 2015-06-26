module Refinery
  module PageRoles
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::PageRoles

      engine_name :refinery_page_roles

      def self.register(tab)
        tab.name = ::I18n.t(:'refinery.plugins.refinery_page_roles.tab_name')
        tab.partial = "/refinery/admin/pages/tabs/roles"
      end

      def self.initialize_tabs!
        PageRoles.config.enabled_tabs.each do |tab_class_name|
          unless (tab_class = tab_class_name.safe_constantize)
            Rails.logger.warn "PageRoles is unable to find tab class: #{tab_class_name}"
            next
          end
          tab_class.register { |tab| register tab }
        end
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "page_roles"
          plugin.hide_from_menu = true
          plugin.pathname = root
        end
      end

      config.after_initialize do
        initialize_tabs!
        Refinery.register_extension(Refinery::PageRoles)
      end
    end
  end
end
