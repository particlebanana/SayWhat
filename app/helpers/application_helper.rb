module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def description(desc)
    content_for(:description) { desc }
  end
    
  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end    
      else
        html << "<h5>#{message}</h5>"
      end  
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end  
  
  def snippit(str, limit=100)
    #str.gsub(/^(.{10}[\w.]*)(.*)/) {$2.empty? ? $1 : $1 + '…'}
    str.split[0..(limit-1)].join(" ") +(str.split.size > limit ? "..." : "") 
  end
  
  # Implements the Paul Irish IE conditional comments HTML tag--in HAML.
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/
  def cc_html(options={}, &blk)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7 ]> <html#{attrs} class='ie6'> <![endif]-->",
      "<!--[if IE 7 ]>    <html#{attrs} class='ie7'> <![endif]-->",
      "<!--[if IE 8 ]>    <html#{attrs} class='ie8'> <![endif]-->",
      "<!--[if IE 9 ]>    <html#{attrs} class='ie9'> <![endif]-->",
      "<!--[if (gt IE 9)|!(IE)]><!--> <html#{attrs}> <!--<![endif]-->",
      capture_haml(&blk).strip,
      "</html>"
    ].join("\n")
  end


end
