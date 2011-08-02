# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SayWhat::Application.initialize!

Haml::Template.options[:format] = :html5

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  '<span class="field_with_errors">'.html_safe << html_tag << 
'</span>'.html_safe
end
