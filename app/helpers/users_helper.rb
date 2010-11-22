module UsersHelper
  
  def settings_navigation(active, links)
    content_tag(:ul, :class => "group", :id => "settingsNav") do
      links.each do |link|
        concat content_tag(:li, content_tag(:a, link.capitalize, :href => '/settings/' + link), :class => ("active" if link == active))
      end
    end
  end
  
end