module Portal
  module Wizard
    module Helper

      def wizard_controller_tag(record)
        raise StandardError if record.nil? or !record.respond_to?(:wizard_steps)

        (content_tag(:div, record.wizard_steps.each_with_index.map { |step, i|
          content_tag(:div, "#{i+1}. " << I18n.t("activerecord.attributes.#{record.class.name.underscore}.wizard_steps.#{step}", :default => step), :class => "w-step"+(record.wizard_step_number == i ? " w-step-current": (record.wizard_step_number > i ? ' w-step-done' : ''))+(record.errors.any? ? " w-step-error": ""))
        }.join(content_tag(:div, "&nbsp;".html_safe, :class => "w-divider")).html_safe, :class => "wizard") << content_tag(:div, "&nbsp;".html_safe, :class => "clear")
        ).html_safe
      end

      def wizard_submit_tag(record, form)
        raise StandardError if record.nil? or !record.respond_to?(:wizard_steps)

        content_tag :div do
          hidden_field_tag(:wizard_back, "1", :disabled => true).html_safe +
              hidden_field_tag(:wizard_create, "1", :disabled => true).html_safe +
              content_tag(:span, form.submit(t(:label_back), :id => "wizard_back_button", :onClick => "$(\"#wizard_back\").attr('disabled', false);", disabled: record.wizard_first_step?, class: 'fbq-button'), style: 'width: 50px; float: left;').html_safe +
              content_tag(:span, form.submit(t(:label_next), :id => "wizard_next_button", disabled: record.wizard_last_step?, class: 'fbq-button'), style: 'width: 50px; float: left;').html_safe +
              content_tag(:span, form.submit(t(:label_create), :id => "wizard_create_button", :onClick => "$(\"#wizard_create\").attr('disabled', false);", disabled: !record.wizard_creatable?, class: 'fbq-button'), style: 'width: 50px; float: left;').html_safe +
              content_tag(:div, "&nbsp;".html_safe, :class => "clear").html_safe
        end
      end

    end
  end
end
