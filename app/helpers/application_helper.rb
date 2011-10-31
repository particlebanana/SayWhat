module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def description(desc)
    content_for(:description) { desc }
  end
    
  def errors_for(object, type='error', message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='alert-message block-message #{type}'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<p>There was a problem creating the #{object.class.name.humanize.downcase}</p>\n"
        else
          html << "\t\t<p>There was a problem updating the #{object.class.name.humanize.downcase}</p>\n"
        end    
      else
        html << "<p>#{message}</p>"
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

  def build_field(type, enum, field_name, object, options)
    html = ""
    if enum
      if object.errors.include? field_name.to_sym
        html << "<div class='clearfix error'>\n"
      else
        html << "<div class='clearfix'>\n"
      end
      html << "#{enum.label field_name.to_sym}\n"
      html << "<div class='input'>\n"
      case type
      when 'text_field'
        html << "#{enum.text_field field_name.to_sym, :class => 'xxlarge'}\n"
      when 'text_area'
        html << "#{enum.text_area field_name.to_sym, :rows => 3, :class => 'xxlarge'}\n"
      when 'select'
        html << "#{enum.select field_name.to_sym, options[:block]}"
      when 'phone'
        html << "#{enum.text_field field_name.to_sym, :class => 'xxlarge', :type => 'tel'}\n"
      end
      html << "<span class='help-inline'>#{options[:inline_block]}</span>\n" if options[:inline_block]
      html << "<span class='help-block'>#{options[:help_block]}</span>\n" if options[:help_block]
      html << "</div>\n"
      html << "</div>\n"
    end
    html
  end

  def flash_messages(flash)
    html = ""
    flash.each do |type, value|
      case type.to_s
      when 'alert'
        html << "<div class='alert-message error fade in' data-alert='alert'>\n"
      when 'notice'
        html << "<div class='alert-message success fade in' data-alert='alert'>\n"
      end
      html << "<a class='close' href='#'>x</a>\n"
      html << "<p><strong>#{value}</strong></p>\n"
      html << "</div>\n"
    end
    html
  end
  
  def snippit(str, limit=100)
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