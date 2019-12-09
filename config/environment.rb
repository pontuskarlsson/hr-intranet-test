# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Portal::Application.initialize!

ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag.html_safe }
